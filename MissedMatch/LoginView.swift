//
//  LoginView.swift
//  MissedMatch
//
//  Created by Shamith Pasula on 5/18/22.
//

import SwiftUI

struct LoginView: View {
    @State private var user = User()
    @State private var isPresentingStatusView = false
    
    var body: some View {
        VStack {
            VStack {
                let logo = UIImage(named: "MissedMatch Logo 2 Full")!
                Image(uiImage: logo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250)
            }
            Spacer()
            Text("Login")
                .font(.title2)
                .padding(.bottom)
            TextField("Username", text: $user.username)
                .padding()
                .frame(width: 250)
                .autocapitalization(.none)
                .background(.ultraThinMaterial)
            SecureField("Password", text: $user.password)
                .padding()
                .frame(width: 250)
                .background(.ultraThinMaterial)
            Button("Submit") {
                isPresentingStatusView = true
            }
            .frame(width: 120.0, height: 45.0)
            .font(.title3)
            .background(Constants.BACKGROUND_COLOR)
            .foregroundColor(Constants.ACCENT_COLOR)
            .cornerRadius(24)
            .padding()
            Spacer()
                .sheet(isPresented: $isPresentingStatusView) {
                // LoginStatusView(loginCase: loginCase)
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
