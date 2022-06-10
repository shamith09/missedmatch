//
//  HomePageView.swift
//  MissedMatch
//
//  Created by Shamith Pasula on 5/24/22.
//

import SwiftUI
import Alamofire

struct HomePageView: View {
    @Binding var user: User
    @Binding var matches: [User]
    
    func getMatches() -> Void {
        AF.request("\(Constants.MATCHES_ROUTE)\(user.id)").response { response in
            debugPrint(response)
        }
    }
    
    var body: some View {
        Button("Get Matches") {
            getMatches()
        }
        .frame(width: Constants.BUTTON_WIDTH + 30, height: Constants.BUTTON_HEIGHT)
        .font(.title3)
        .background(Constants.BACKGROUND_COLOR)
        .foregroundColor(Constants.ACCENT_COLOR)
        .cornerRadius(24)
        .padding()
    }
}

struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView(user: .constant(.sampleUser), matches: .constant([User.sampleUser]))
    }
}


