//
//  LoginView.swift
//  MissedMatch
//
//  Created by Shamith Pasula on 5/18/22.
//

import SwiftUI
import Alamofire

struct LoginView: View {
    @State private var login = Login()
    @State private var secured = true
    
    @Binding var user: User
    @Binding var loginStatus: LoginStatus
    
    func request() -> Void {
        AF.request(Constants.USER_ROUTE, parameters: login).responseDecodable(of: User.self) { response in
            switch response.result {
            case .success:
                user = response.value!
                loginStatus = .success
            case .failure:
                loginStatus = .failure
            }
        }
    }
    var body: some View {
        let foregroundColor: Color = loginStatus == .processing ? .gray : .primary
        VStack {
            TextField("Username", text: $login.username)
                .padding()
                .frame(width: Constants.FIELD_WIDTH)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .background(.ultraThinMaterial)
                .foregroundColor(foregroundColor)
            HStack {
                if secured {
                    SecureField("Password", text: $login.password)
                        .autocapitalization(.none)
                } else {
                    TextField("Password", text: $login.password)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
                Button(action: {
                    self.secured.toggle()
                }) {
                    if secured {
                        Image(systemName: "eye")
                    } else {
                        Image(systemName: "eye.slash")
                    }
                }
            }
            .padding()
            .frame(width: Constants.FIELD_WIDTH)
            .background(.ultraThinMaterial)
            .foregroundColor(foregroundColor)
            if loginStatus == .failure {
                Text("Wrong username or password. Try again.")
                    .foregroundColor(.red)
                    .font(.caption)
            }
            Button("Login") {
                loginStatus = .processing
                request()
            }
            .disabled(!login.isComplete)
            .frame(width: Constants.BUTTON_WIDTH, height: Constants.BUTTON_HEIGHT)
            .font(.title3)
            .background(login.isComplete ? Constants.BACKGROUND_COLOR : .gray)
            .foregroundColor(Constants.ACCENT_COLOR)
            .cornerRadius(24)
            .padding()
            Text("If you don't have an account yet,")
                .padding(.top)
            NavigationLink(destination: SignupView(user: $user, loginStatus: $loginStatus)) {
                Text("Sign Up")
            }
            .frame(width: Constants.BUTTON_WIDTH, height: Constants.BUTTON_HEIGHT)
            .font(.title3)
            .background(Constants.BACKGROUND_COLOR)
            .foregroundColor(Constants.ACCENT_COLOR)
            .cornerRadius(24)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(user: .constant(.sampleUser), loginStatus: .constant(.pending))
    }
}
