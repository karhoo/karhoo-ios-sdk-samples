//
//  KarhooConfiguration.swift
//  Network SDK SwiftUI Sample
//
//  Created by Mostafa Hadian on 13/08/2020.
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

final class KarhooSandboxConfiguration: KarhooSDKConfiguration {
    
    static var onUpdateAuthentication: (@escaping () -> Void) -> Void = { $0() }
    
    static var authenticationMethod = AuthenticationMethod.karhooUser
    
    func environment() -> KarhooEnvironment {
        return KarhooEnvironment.sandbox
    }
    
    func authenticationMethod() -> AuthenticationMethod {
        return KarhooSandboxConfiguration.authenticationMethod
    }
    
    func requireSDKAuthentication(callback: @escaping () -> Void) {
        KarhooSandboxConfiguration.onUpdateAuthentication {
            callback()
        }
    }
}
