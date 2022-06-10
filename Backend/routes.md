/users:

    POST - to signup:
    
    Query: {
        username: str
        password: str
        age: int
        profile_pic: image?
        other_pics: [image]?
        location: [double]
    }

    Response: {
        _id: ObjectId
    }

    GET - to login

    Query: {
        username: str
        password: str
    }

    Response: {
        _id: ObjectId
        username: str
        age: int
        creation_date: int
        profile_pic: image
        other_pics: [image]
        location: [double]
    }
