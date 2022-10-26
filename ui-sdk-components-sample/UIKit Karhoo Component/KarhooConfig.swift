//
//  KarhooConfig.swift
//  UIKit Karhoo Component
//
//  Created by Jeevan Thandi on 26/11/2020.
//

import KarhooUISDK
import KarhooSDK

struct KarhooConfig: KarhooUISDKConfiguration {
    static var onUpdateAuthentication: (@escaping () -> Void) -> Void = { $0() }
    
    var paymentManager: KarhooUISDK.PaymentManager {
        BraintreePaymentManager()
    }
    
    func environment() -> KarhooEnvironment {
        return .sandbox
    }

    func authenticationMethod() -> AuthenticationMethod {
        return .karhooUser
    }
    
    func requireSDKAuthentication(callback: @escaping () -> Void) {
        print("Client: KarhooConfig.requireSDKAuthentication started")
        KarhooConfig.onUpdateAuthentication {
            print("Client: KarhooConfig.requireSDKAuthentication finished")
            callback()
        }
    }
}
