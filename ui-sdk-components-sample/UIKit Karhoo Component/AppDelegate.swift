//
//  AppDelegate.swift
//  UIKit Karhoo Component
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import UIKit
import KarhooUISDK
import KarhooSDK
import Braintree

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    static let braintree3DsURLScheme = "karhoo.UIKit-Karhoo-Component.braintree"
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        KarhooUI.set(configuration: KarhooConfig())
        BTAppSwitch.setReturnURLScheme(AppDelegate.braintree3DsURLScheme)
        window = UIWindow()

        let viewController = LoginViewController()
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        return true
    }
    
    // support braintree
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
        if url.scheme?.localizedCaseInsensitiveCompare(AppDelegate.braintree3DsURLScheme) == .orderedSame {
            return BTAppSwitch.handleOpen(url, options: options)
        }
        return false
    }
}

extension UIView {

    func pinEdges(to view: UIView, spacing: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        pinLeftRightEdegs(to: view, leading: spacing, trailing: -spacing)
        pinTopBottomEdegs(to: view, top: spacing, bottom: -spacing)
    }

    func pinLeftRightEdegs(to view: UIView, leading: CGFloat = 0, trailing: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leading).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: trailing).isActive = true
    }

    func pinTopBottomEdegs(to view: UIView, top: CGFloat = 0, bottom: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: view.topAnchor, constant: top).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottom).isActive = true
    }
}
