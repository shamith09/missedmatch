//
//  SignupView.swift
//  MissedMatch
//
//  Created by Shamith Pasula on 5/24/22.
//

import SwiftUI
import Alamofire

struct SignupView: View {
    @State private var signup = Signup()
    @State private var birthDate = Date()
    @State private var secured = true
    
    @Binding var user: User
    @Binding var loginStatus: LoginStatus
    
    @EnvironmentObject var locationManager: LocationManager

    func request() -> Void {
        AF.request(Constants.USER_ROUTE, method: .post, parameters: signup).responseDecodable(of: User.self) { response in
            switch response.result {
            case .success:
                user = response.value!
                locationManager.id = user.id
                loginStatus = .success
            case .failure:
                loginStatus = .failure
            }
        }
    }
    var intProxy: Binding<Double> {
        Binding<Double>(get: {
            return Double(signup.age)
        }, set: {
            signup.age = Int($0)
        })
    }
    var body: some View {
        let foregroundColor: Color = loginStatus == .processing ? .gray : .primary
        VStack {
            TextField("Name", text: $signup.name)
                .frame(width: Constants.FIELD_WIDTH)
                .padding()
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .background(.ultraThinMaterial)
                .foregroundColor(foregroundColor)
            DatePicker("Birthday", selection: $birthDate, in: ...Date(), displayedComponents: .date)
                .frame(width: Constants.FIELD_WIDTH)
                .padding(.vertical)
            if Date.now.years(from: birthDate) < Constants.MIN_AGE {
                Text("You must be at least \(Constants.MIN_AGE) years old to use this app.")
                    .font(.caption)
                    .padding(.bottom)
                    .foregroundColor(.red)
            }
            TextField("Username", text: $signup.username)
                .frame(width: Constants.FIELD_WIDTH)
                .padding()
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .background(.ultraThinMaterial)
                .foregroundColor(foregroundColor)
            if loginStatus == .failure {
                Text("Username is taken. Try again.")
                    .foregroundColor(.red)
                    .font(.caption)
            }
            HStack {
                if secured {
                    SecureField("Password", text: $signup.password)
                        .autocapitalization(.none)
                } else {
                    TextField("Password", text: $signup.password).autocapitalization(.none)
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
            .frame(width: Constants.FIELD_WIDTH)
            .padding()
            .background(.ultraThinMaterial)
            .foregroundColor(foregroundColor)
            if signup.password.count < Constants.PASSWORD_LENGTH {
                Text("Password must be at least 8 characters long.")
                    .font(.caption)
                    .foregroundColor(.red)
            }
            Button("Sign Up") {
                loginStatus = .processing
                signup.age = Date.now.years(from: birthDate)
                signup.latitude = Double((locationManager.location?.coordinate.latitude)!)
                signup.longitude = Double((locationManager.location?.coordinate.longitude)!)
                request()
            }
            .disabled(!signup.isComplete || Date.now.years(from: birthDate) < Constants.MIN_AGE)
            .frame(width: Constants.BUTTON_WIDTH, height: Constants.BUTTON_HEIGHT)
            .font(.title3)
            .background(signup.isComplete && Date.now.years(from: birthDate) >= Constants.MIN_AGE ? Constants.BACKGROUND_COLOR : .gray)
            .foregroundColor(Constants.ACCENT_COLOR)
            .cornerRadius(24)
            .padding()
        }
        .onAppear {
            loginStatus = .pending
        }
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView(user: .constant(.sampleUser), loginStatus: .constant(.pending))
    }
}

extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
}

