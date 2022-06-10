//
//  Signup.swift
//  MissedMatch
//
//  Created by Shamith Pasula on 5/24/22.
//

import Foundation
import Metal

struct Signup: Codable {
    var username: String
    var name: String
    var age: Int
    var password: String
    var latitude: Double
    var longitude: Double
    
    init(username: String = "", name: String = "", age: Int = 0, password: String = "", latitude: Double = 0, longitude: Double = 0) {
        self.username = username
        self.name = name
        self.age = age
        self.password = password
        self.latitude = latitude
        self.longitude = longitude
    }
    
    var isComplete: Bool {
        !(username.isEmpty || name.isEmpty || password.count < Constants.PASSWORD_LENGTH)
    }
}
