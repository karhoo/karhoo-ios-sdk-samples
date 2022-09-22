
import Foundation

import KarhooSDK
import KarhooUISDK

final class KarhooConfig: KarhooUISDKConfiguration {
    var paymentManager: PaymentManager {
            BraintreePaymentManager()
        }

    static var auth: AuthenticationMethod = .karhooUser
    static var environment: KarhooEnvironment = .sandbox

    func environment() -> KarhooEnvironment {
        return KarhooConfig.environment
    }

    func authenticationMethod() -> AuthenticationMethod {
        return KarhooConfig.auth
    }
}
