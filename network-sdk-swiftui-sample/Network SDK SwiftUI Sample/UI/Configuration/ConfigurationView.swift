//
//  ConfigurationView.swift
//  Network SDK SwiftUI Sample
//
//  Created by Mostafa Hadian on 13/08/2020.
//  Copyright © 2020 Karhoo. All rights reserved.
//

import SwiftUI
import KarhooSDK

struct ConfigurationView: View {
    @Binding var tabSelection: Int
    
    @State private var username = ""
    @State private var password = ""
    @State private var showingAlert = false
    @State private var message = ""
    @State private var loginSuccess = false
    
    @EnvironmentObject var bookingStatus: BookingStatus
    
    let loginService: UserService = Karhoo.getUserService()
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                Text("Login")
                    .textStyle(TitleStyle())
                VStack {
                    TextField("Username", text: self.$username)
                        .padding()
                    TextField("Password", text: self.$password)
                        .padding()
                    Button("Sign In", action: attemptLoginWith)
                        .buttonStyle(ActionButtonStyle())
                        .frame(width: 300, height: 50)
                        .background(Color(red: 0.28, green: 0.20, blue: 0.83))
                        .cornerRadius(StyleConstants.cornerRadius)
                }
                .padding()
                .background(Color(red: 0.90, green: 0.90, blue: 1.00))
                .cornerRadius(StyleConstants.cornerRadius)
                Spacer()
            }
            .padding(10)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 0.55, green: 0.49, blue: 1.00))
        }
    }
    
    private func attemptLoginWith() {
        
        let userLogin = UserLogin(username: self.username, password: self.password)
        loginService.login(userLogin: userLogin)
            .execute(callback: { result in
                self.loginComplete(result: result)
            })
    }
    
    private func loginComplete(result: Result<UserInfo>) {
        switch result {
        case .success:
            loginSucceed()
        case .failure:
            loginFailed(message: result.errorValue()?.localizedDescription ?? "Error unauthorized")
        }
    }
    
    private func loginSucceed() {
        self.tabSelection = 1
    }
    
    private func loginFailed(message: String){
        self.showingAlert = true
        self.message = message
    }
}

struct ConfigurationView_Previews: PreviewProvider {
    @State static var tabSelection: Int = 0
    
    static var previews: some View {
        ConfigurationView(tabSelection: $tabSelection)
    }
}
