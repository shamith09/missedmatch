from os import getenv
from dotenv import load_dotenv
from flask import Flask, request
from pymongo import MongoClient
from pymongo.server_api import ServerApi
from time import time
from bson.objectid import ObjectId
from passlib.hash import sha256_crypt as sha256

DISTANCE_THRESHOLD = .001

app = Flask(__name__)
load_dotenv()

client = MongoClient(f"mongodb+srv://{getenv('MONGO_USERNAME')}:{getenv('MONGO_PASSWORD')}@plextime.dmmb7.mongodb.net/?retryWrites=true&w=majority", server_api=ServerApi('1'))
db = client.plextime

@app.after_request
def after_request(response):
    header = response.headers
    header['Access-Control-Allow-Origin'] = '*'
    return response

def format(u):
    u.pop('password')
    u['id'] = str(u['_id'])
    u.pop('_id')
    return u

@app.route('/users/<user_id>', methods=['GET', 'PUT', 'DELETE'])
def users(user_id):
    id = ObjectId(user_id)
    if request.method == 'GET':
        user = db.Users.find_one({'_id': id})
        if not user:
            return {'message': 'Not Found'}, 404
        return format(user), 200
    elif request.method == 'DELETE':
        if request.form.get('password') != getenv('MONGO_PASSWORD'):
            return {'message': 'Unauthorized'}, 401
        if db.Users.delete_one({'_id': id}).deleted_count == 0:
            return {'message': 'Not Found'}, 404
        return {'message': 'User successfully deleted!'}, 200
    elif request.method == 'PUT':
        if request.form.get('location_update'):
            if db.Users.update_one({'_id': id}, {'$set': {
                'latitude': request.form.get('latitude'),
                'longitude': request.form.get('longitude')
            }}).matched_count == 0:
                return {'message': 'Not Found'}, 404
            return matches(user_id)
        else:
            user = db.Users.find_one({'_id': id})
            if not user:
                return {'message': 'Not Found'}, 404
            fields = set('username', 'password', 'creation_time', 'location', 'age')
            user.update({k: request.form.get(k) for k in request.form if k in fields})
            db.Users.replace_one({'_id': id}, user)
            return {'message': 'User successfully updated!'}, 200

@app.route('/users', methods=['POST', 'GET'])
def login():
    if request.method == 'POST':
        user = db.Users.find_one({'username': request.form.get('username')})
        if user:
            return {'message': 'Need unique username'}, 400
        user = {
            'username': request.form.get('username'),
            'name': request.form.get('name'),
            'password': sha256.hash(request.form.get('password')),
            'creation_time': int(time()),
            'age': int(request.form.get('age')),
            'latitude': float(request.form.get('latitude')),
            'longitude': float(request.form.get('longitude'))
            #'profile_pic': request.files.get('profile_pic'),
            #'other_pics': request.files.getlist('other_pics')
        }
        db.Users.insert_one(user)
    elif request.method == 'GET':
        user = db.Users.find_one({'username': request.args.get('username')})
        if user is None:
            return {'error': 'Wrong username'}, 404
        if not sha256.verify(request.args.get('password'), user.get('password')):
            return {'error': 'Wrong password'}, 403
    return format(user), 200

@app.route('/matches/<user_id>')
def matches(user_id):
    user = db.Users.find_one({'_id': ObjectId(user_id)})
    if not user:
        return {'message': 'Not Found'}, 404
    matches = db.Users.find({
        '_id': {'$ne': ObjectId(user_id)},
        'latitude': {
            '$lte': user.get('latitude') + DISTANCE_THRESHOLD,
            '$gte': user.get('latitude') - DISTANCE_THRESHOLD
        },
        'longitude': {
            '$lte': user.get('longitude') + DISTANCE_THRESHOLD,
            '$gte': user.get('longitude') - DISTANCE_THRESHOLD
        }
    })
    res = list(map(format, matches))
    return {'matches': res}, 200

if __name__ == '__main__':
    app.run(debug=getenv('DEBUG'), port=getenv('PORT'))