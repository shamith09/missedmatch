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
    
    static let FIELD_WIDTH: CGFloat = 250
    static let FIELD_HEIGHT: CGFloat = 55
    static let BUTTON_WIDTH: CGFloat = 120
    static let BUTTON_HEIGHT: CGFloat = 40
    
    static let BACKEND_URL = "http://localhost:8080"
//    static let BACKEND_URL = "https://fbc5-2405-201-c00c-2259-a5e6-9db0-7a7f-1886.ngrok.io"
    static let USER_ROUTE = "\(BACKEND_URL)/users"
    static let MATCHES_ROUTE = "\(BACKEND_URL)/matches/"
    
    static let MIN_AGE = 13
    static let PASSWORD_LENGTH = 8
}
