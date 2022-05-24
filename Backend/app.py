from os import getenv
from dotenv import load_dotenv
from flask import Flask, request
from pymongo import MongoClient
from pymongo.server_api import ServerApi
from time import time
from bson.objectid import ObjectId
from passlib.hash import sha256_crypt as sha256

app = Flask(__name__)
load_dotenv()

client = MongoClient(f"mongodb+srv://{getenv('MONGO_USERNAME')}:{getenv('MONGO_PASSWORD')}@plextime.dmmb7.mongodb.net/?retryWrites=true&w=majority", server_api=ServerApi('1'))
db = client.plextime

@app.after_request
def after_request(response):
    header = response.headers
    header['Access-Control-Allow-Origin'] = '*'
    return response

@app.route('/users/<user_id>', methods=['GET', 'PUT', 'DELETE'])
def users(user_id):
    id = ObjectId(user_id)
    if request.method == 'GET':
        user = db.Users.find_one({'_id': id})
        if user:
            user.pop('password')
            user['id'] = str(user['_id'])
            user.pop('_id')
            return user, 200
        return {'error': 'Not Found'}, 404
    elif request.method == 'DELETE':
        if db.Users.delete_one({'_id': id}).deleted_count == 0:
            return {'error': 'Not Found'}, 404
        return {'message': 'User successfully deleted!'}, 200

@app.route('/users', methods=['POST', 'GET'])
def signup():
    user = db.Users.find_one({'username': request.form.get('username')})
    if request.method == 'POST':
        if user:
            return {'message': 'Need unique username'}, 400
        user = {
            'username': request.form.get('username'),
            'name': request.form.get('name'),
            'password': sha256.hash(request.form.get('password')),
            'creation_time': int(time()),
            'age': int(request.form.get('age')),
            #'profile_pic': request.files.get('profile_pic'),
            #'other_pics': request.files.getlist('other_pics')
        }
        db.Users.insert_one(user)
    elif request.method == 'GET':
        if user is None:
            return {'error': 'Wrong username'}, 404
        if not sha256.verify(request.args.get('password'), user.get('password')):
            return {'error': 'Wrong password'}, 403
    user.pop('password')
    user['id'] = str(user['_id'])
    user.pop('_id')
    return user, 200
    
if __name__ == '__main__':
    app.run(debug=getenv('DEBUG'), port=getenv('PORT'))