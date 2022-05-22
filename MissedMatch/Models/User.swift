//
//  User.swift
//  MissedMatch
//
//  Created by Shamith Pasula on 5/18/22.
//

import Foundation
import UIKit

struct User: Identifiable, Decodable {
    let id: UUID
    var username: String
    var name: String
    var age: Int
    var password: String
    var creation_date: Int
    
    init(id: UUID = UUID(), username: String = "", name: String = "", age: Int = 0, password: String = "", creation_date: Int = 0) {
        self.id = id
        self.username = username
        self.name = name
        self.age = age
        self.password = password
        self.creation_date = creation_date
    }
    
    static let sampleUser: User = User(username: "shamyth", name: "Shamith Pasula", age: 18)
}
