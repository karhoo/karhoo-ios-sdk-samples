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

protocol SampleView {
    func setUpView()
    func quoteListHidden(_ hidden: Bool)
    func dismissTopViewController()
    func presentView(viewController: UIViewController)
}

class ViewController: UIViewController, SampleView {

    let presenter: ViewControllerPresenter = ViewControllerPresenter()

    // address bar component
    private lazy var addressBar: AddressBarView = {
        let addressBar = KarhooUI.components.addressBar(journeyInfo: nil)
        addressBar.translatesAutoresizingMaskIntoConstraints = false
        return addressBar
    }()

    // address bar component
    private lazy var quoteList: QuoteListView = {
        let quoteList = KarhooUI.components.quoteList()
        quoteList.set(quoteListActions: self)
        return quoteList
    }()

    // quote list is a view controller so it must be contained in a view
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

    // Observable object shared accross all components / karhoo screens
    private var bookingStatus = KarhooBookingStatus.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        presenter.didLoad(view: self)
    }

    // layout component constraints
    func setUpView() {
        self.view.addSubview(addressBar)
        self.view.addSubview(titleLabel)
        self.view.addSubview(quoteListContainer)


        [titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
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
extension ViewController: QuoteListActions {
    func quotesAvailabilityDidUpdate(availability: Bool) {
        print("quotesAvailabilityDidUpdate: ", availability)
    }

    func didSelectQuote(_ quote: Quote) {
        presenter.didSelect(quote: quote)
    }
}
