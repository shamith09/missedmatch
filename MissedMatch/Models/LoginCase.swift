//
//  LoginCase.swift
//  MissedMatch
//
//  Created by Shamith Pasula on 5/20/22.
//

import Foundation

enum LoginCase {
    case success
    case wrong
    case error
    
    func toString() -> String {
        switch self {
        case .success: return "Success"
        case .error: return "Error"
        case .wrong: return "Wrong username or password"
        }
    }
}
