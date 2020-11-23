//
//  SwiftUIComponentsApp.swift
//  SwiftUIComponents
//
//  Created by Jeevan Thandi on 19/11/2020.
//

import SwiftUI
import KarhooSDK
import KarhooUISDK

@main
struct SwiftUIComponentsApp: App {

    init() {
        KarhooUI.set(configuration: KarhooConfig())
        authenticateKarhoo()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }

    func authenticateKarhoo() {
        if Karhoo.configuration.authenticationMethod().guestSettings != nil {
            return
        } else {
            let userService = Karhoo.getUserService()

            userService.login(userLogin: Keys.userLogin).execute(callback: { result in
                                                    switch result {
                                                    case .success(_ ):
                                                        break
                                                    case .failure(let error):
                                                        print("error! \(String(describing: error ?? nil))")
                                                    }
                                                   })
        }
    }
}
