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
    @State private var loginStatus = LoginStatus.loading
    @State private var matches: [User] = []
    @State private var errorWrapper: ErrorWrapper?
    @State private var store = UserStore()
    @Environment(\.scenePhase) private var scenePhase
    
    @StateObject private var locationManager = LocationManager()
    
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                if loginStatus == .success {
                    HomePageView(user: $store.user, matches: $matches)
                } else {
                    LoginView(user: $store.user, loginStatus: $loginStatus)
                }
            }
            .environmentObject(locationManager)
            .sheet(item: $errorWrapper) { wrapper in
                ErrorView(errorWrapper: wrapper)
            }
            .onAppear {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) {
                    success, error in
                        if let error = error {
                            print(error)
                        }
                }
            }
            .onChange(of: scenePhase) { phase in
                if phase == .inactive {
                    Task {
                        do {
                            try await UserStore.save(user: store.user)
                        } catch {
                            errorWrapper = ErrorWrapper(error: error, guidance: "Try again later.")
                        }
                    }
                }
            }
            .task {
                do {
                    store.user = try await UserStore.load()
                    if (store.user.id.isEmpty) {
                        loginStatus = .pending
                    } else {
                        loginStatus = .success
                    }
                    locationManager.id = store.user.id
                } catch {
                    errorWrapper = ErrorWrapper(error: error, guidance: "Error loading user.")
                }
            }
        }
    }
}

