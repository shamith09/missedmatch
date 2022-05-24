//
//  MissedMatchApp.swift
//  MissedMatch
//
//  Created by Shamith Pasula on 5/18/22.
//

import SwiftUI

// main color: (0, 179, 255)
@main
struct MissedMatchApp: App {
    @State private var user = User()
    @State private var loginStatus = LoginStatus.pending
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                LoginView(user: $user, loginStatus: $loginStatus)
            }
        }
    }
}

