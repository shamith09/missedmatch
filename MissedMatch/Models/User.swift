//
//  User.swift
//  MissedMatch
//
//  Created by Shamith Pasula on 5/18/22.
//

import Foundation
import UIKit

struct User: Codable {
    var id: String
    var username: String
    var name: String
    var age: Int
    var creation_time: Int
    var latitude: Double
    var longitude: Double
    
    init(id: String = "", username: String = "", name: String = "", age: Int = 0, creation_time: Int = 0, latitude: Double = 0, longitude: Double = 0) {
        self.id = id
        self.username = username
        self.name = name
        self.age = age
        self.creation_time = creation_time
        self.latitude = latitude
        self.longitude = longitude
    }
    
    static let sampleUser: User = User(username: "shamyth", name: "Shamith Pasula", age: 18)
}
