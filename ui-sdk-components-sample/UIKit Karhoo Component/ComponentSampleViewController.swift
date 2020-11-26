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
    func setUpView()
    func quoteListHidden(_ hidden: Bool)
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

    // A scrollable list of quotes based on the set booking details
    private lazy var quoteList: QuoteListView = {
        let quoteList = KarhooUI.components.quoteList()
        quoteList.set(quoteListActions: self)
        return quoteList
    }()

    // QuoteList component is a view controller so it must be contained to be embedded
    private lazy var quoteListContainer: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.isHidden = true
        return container
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Karhoo UIKit Components Demo"
        label.font = UIFont(name: "Roboto", size: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var signOutButton: UIButton = {
        return UIBuilder.button(title: "Sign Out", titleColor: .red)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        presenter.didLoad(view: self)
        setUpView()
    }

    // layout component constraints / Alternatively bind through storyboard
    func setUpView() {
        self.view.addSubview(addressBar)
        self.view.addSubview(titleLabel)
        self.view.addSubview(quoteListContainer)
        self.view.addSubview(signOutButton)

        signOutButton.addTarget(self, action: #selector(signOutPressed), for: .touchUpInside)

        [signOutButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
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

        [quoteListContainer.heightAnchor.constraint(equalToConstant: 400),
         quoteListContainer.widthAnchor.constraint(equalTo: view.widthAnchor),
         quoteListContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor)].forEach { constraint in
            constraint.isActive = true
         }

        addChild(quoteList)
        quoteListContainer.addSubview(quoteList.view)
        quoteList.view.pinEdges(to: quoteListContainer)
        quoteList.didMove(toParent: self)
    }

    @objc private func signOutPressed() {
        KarhooBookingStatus.shared.reset()
        let userService = Karhoo.getUserService()
        userService.logout().execute { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }
    }
}

// ViewControllers external interface
extension ComponentSampleViewController: ComponentSampleViewControllerP {
    func quoteListHidden(_ hidden: Bool) {
        quoteListContainer.isHidden = hidden
    }

    func dismissTopViewController() {
        self.dismiss(animated: true, completion: nil)
    }

    func presentView(viewController: UIViewController) {
        self.present(viewController, animated: true, completion: nil)
    }
}

// Quote list component output
extension ComponentSampleViewController: QuoteListActions {
    func quotesAvailabilityDidUpdate(availability: Bool) {
        print("quotesAvailabilityDidUpdate: ", availability)
    }

    func didSelectQuote(_ quote: Quote) {
        presenter.didSelect(quote: quote)
    }
}
