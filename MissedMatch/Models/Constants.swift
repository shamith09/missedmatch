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
    
    static let BACKGROUND_COLOR : Color = Color(red: 0, green: 179/255, blue: 1)
    static let ACCENT_COLOR : Color = colorScheme == .dark ? .white : .black
    
    static let BACKEND_URL = URL(string: "localhost:8080")!
}
