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
    if request.method == 'GET':
        user = db.Users.find_one({'_id': ObjectId(user_id)})
        if user is None:
            return {'error': 'Not Found'}, 404
        user.pop('password')
        user['id'] = str(user['_id'])
        user.pop('_id')
        return user, 200

@app.route('/users', methods=['POST', 'GET'])
def signup():
    if request.method == 'POST':
        if db.Users.find_one({'username': request.form.get('username')}) is not None:
            return {'error': 'Need unique username'}, 400
        user = {
            'username': request.form.get('username'),
            'password': sha256.hash(request.form.get('password')),
            'creation_time': int(time()),
            'age': request.form.get('age'),
            #'profile_pic': request.files.get('profile_pic'),
            #'other_pics': request.files.getlist('other_pics')
        }
        return {'_id': str(db.Users.insert_one(user).inserted_id)}, 200
    elif request.method == 'GET':
        user = db.Users.find_one({'username': request.form.get('username')})
        if user is None:
            return {'error': 'Wrong username'}, 404
        if not sha256.verify(request.form.get('password'), user.get('password')):
            return {'error': 'Wrong password'}, 403
        user.pop('password')
        user['id'] = str(user['_id'])
        user.pop('_id')
        return user, 200
    
if __name__ == '__main__':
    app.run(debug=getenv('DEBUG'), port=getenv('PORT'))