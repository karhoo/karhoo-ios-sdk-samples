
import Foundation

import KarhooSDK
import KarhooUISDK

final class KarhooConfig: KarhooUISDKConfiguration {
    static var onUpdateAuthentication: (@escaping () -> Void) -> Void = { $0() }
    
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
    
    func requireSDKAuthentication(callback: @escaping () -> Void) {
        print("Client: KarhooConfig.requireSDKAuthentication started")
        KarhooConfig.onUpdateAuthentication {
            print("Client: KarhooConfig.requireSDKAuthentication finished")
            callback()
        }
    }
}
