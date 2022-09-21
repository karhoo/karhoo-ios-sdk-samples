//
//  KarhooConfig.swift
//  UIKit Karhoo Component
//
//  Created by Jeevan Thandi on 26/11/2020.
//

import KarhooUISDK
import KarhooSDK

struct KarhooConfig: KarhooUISDKConfiguration {
    var paymentManager: KarhooUISDK.PaymentManager {
        BraintreePaymentManager()
    }
    
    func environment() -> KarhooEnvironment {
        return .sandbox
    }

    func authenticationMethod() -> AuthenticationMethod {
        return .karhooUser
    }
}
