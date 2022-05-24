//
//  Login.swift
//  MissedMatch
//
//  Created by Shamith Pasula on 5/22/22.
//

import Foundation

struct Login: Codable {
	var username: String
	var password: String
	
	init(username: String = "", password: String = "") {
		self.username = username
		self.password = password
	}
	
	var isComplete: Bool {
		!(username.isEmpty || password.count < Constants.PASSWORD_LENGTH)
	}
}
