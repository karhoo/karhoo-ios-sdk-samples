//
//  ViewController.swift
//  UIKit Karhoo Component
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import UIKit
import KarhooUISDK
import KarhooSDK
import SwiftSpinner

protocol ComponentSampleViewControllerP {
    var navController: UINavigationController? { get }
    func setUpView()
    func dismissTopViewController()
    func presentView(viewController: UIViewController)
}

class ComponentSampleViewController: UIViewController {

    let presenter: ComponentSamplePresenterP = ComponentSamplePresenter()

    // addressBar: Allows user to set booking details
    private lazy var addressBar: AddressBarView = {
        let addressBar = KarhooUI.components.addressBar(journeyInfo: nil)
        addressBar.translatesAutoresizingMaskIntoConstraints = false
        return addressBar
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Karhoo UIKit Components Demo"
        label.font = UIFont(name: "Roboto", size: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var signOutButton: UIButton = {
        let button = UIBuilder.button(title: "Sign Out", titleColor: .red)
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 8
        return button
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setUpView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        presenter.didLoad(view: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        presenter.didAppear(view: self)
    }

    // layout component constraints / Alternatively bind through storyboard
    func setUpView() {
        self.view.addSubview(addressBar)
        self.view.addSubview(titleLabel)
        self.view.addSubview(signOutButton)

        signOutButton.addTarget(self, action: #selector(signOutPressed), for: .touchUpInside)

        [signOutButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 50),
         signOutButton.widthAnchor.constraint(equalToConstant: 120),
         signOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)].forEach { constraint in
            constraint.isActive = true
         }

        [titleLabel.topAnchor.constraint(equalTo: signOutButton.bottomAnchor, constant: 50),
         titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0)].forEach { constraint in
            constraint.isActive = true
         }

        [addressBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
         addressBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
         addressBar.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
         addressBar.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
         addressBar.heightAnchor.constraint(greaterThanOrEqualToConstant: 100)].forEach { constraint in
            constraint.isActive = true
         }
    }

    @objc private func signOutPressed() {
        KarhooJourneyDetailsManager.shared.reset()
        let userService = Karhoo.getUserService()
        userService.logout().execute { [weak self] _ in
            self?.navigationController?.popToRootViewController(animated: true)
        }
    }
}

// ViewControllers external interface
extension ComponentSampleViewController: ComponentSampleViewControllerP {
    var navController: UINavigationController? {
        get {
            self.navigationController
        }
    }

    func dismissTopViewController() {
        self.dismiss(animated: true, completion: nil)
    }

    func presentView(viewController: UIViewController) {
        self.present(viewController, animated: true, completion: nil)
    }
}
