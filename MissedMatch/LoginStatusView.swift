//
//  LoginStatusView.swift
//  MissedMatch
//
//  Created by Shamith Pasula on 5/20/22.
//

import SwiftUI

struct LoginStatusView: View {
    let loginCase: LoginCase
    
    var body: some View {
        Text("\(loginCase.toString())")
    }
}

struct LoginStatusView_Previews: PreviewProvider {
    static var previews: some View {
        LoginStatusView(loginCase: LoginCase.success)
    }
}
