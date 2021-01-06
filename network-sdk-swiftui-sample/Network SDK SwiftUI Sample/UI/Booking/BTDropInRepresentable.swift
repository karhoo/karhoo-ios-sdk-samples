//
//  BTDropInRepresentable.swift
//  Network SDK SwiftUI Sample
//
//  Created by Jo Santamaria on 22/12/2020.
//  Copyright © 2020 Karhoo. All rights reserved.
//

import SwiftUI
import BraintreeDropIn

struct BTDropInRepresentable: UIViewControllerRepresentable {
    var authorization: String
    var handler: BTDropInControllerHandler
    
    init(authorization: String, handler: @escaping BTDropInControllerHandler) {
        self.authorization = authorization
        self.handler = handler
    }
    
    func makeUIViewController(context: Context) -> BTDropInController {
        let bTDropInController = BTDropInController(authorization: authorization, request: BTDropInRequest(), handler: handler)!
        return bTDropInController
    }
    
    func updateUIViewController(_ uiViewController: BTDropInController, context: UIViewControllerRepresentableContext<BTDropInRepresentable>) {
    }
}
