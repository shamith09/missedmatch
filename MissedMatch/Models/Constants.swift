//
//  Constants.swift
//  MissedMatch
//
//  Created by Shamith Pasula on 5/20/22.
//

import Foundation
import SwiftUI

struct Constants {
    @Environment(\.colorScheme) static var colorScheme
    
    static let BACKGROUND_COLOR = Color(red: 0, green: 179/255, blue: 1)
    static let ACCENT_COLOR: Color = colorScheme == .dark ? .white : .black
    
    static let FIELD_WIDTH: CGFloat = 280
    static let BUTTON_WIDTH: CGFloat = 120
    static let BUTTON_HEIGHT: CGFloat = 40
    
    static let BACKEND_URL = "http://localhost:8080"
    static let USER_ROUTE = "\(BACKEND_URL)/users"
    
    static let MIN_AGE = 13
    static let PASSWORD_LENGTH = 8
}
