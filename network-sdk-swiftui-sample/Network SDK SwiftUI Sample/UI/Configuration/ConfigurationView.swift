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
        ZStack {
            VStack {
                Text("Login")
                    .font(.title)
                    .padding()
                TextField("Username", text: self.$username)
                    .padding()
                    .cornerRadius(20.0)
                TextField("Password", text: self.$password)
                    .padding()
                    .cornerRadius(20.0)
                Button(action: attemptLoginWith ) {
                    Text("Sign In")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color(red: 0.28, green: 0.20, blue: 0.83))
                        .cornerRadius(15.0)
                }
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Sample App"), message: Text(self.message), dismissButton: .default(Text("Got it!")))
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(red: 0.90, green: 0.90, blue: 1.00))
            .padding(10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 0.55, green: 0.49, blue: 1.00))
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
        case let .failure(error):
            loginFailed(message: error?.localizedDescription ?? "Error unauthorized")
        }
    }
    
    private func loginSucceed() {
//        self.showingAlert = true
//        self.message = "Login Succeed"
//        guard let user = loginService.getCurrentUser() else { return }
//        self.message.append(" for \(user.firstName) \(user.lastName)")
        self.tabSelection = 1
    }
    
    private func loginFailed(message: String){
        self.showingAlert = true
        self.message = message
    }
}

//struct ConfigurationView_Previews: PreviewProvider {
//    static var previews: some View {
//        ConfigurationView(selectedTab: 0)
//    }
//}
