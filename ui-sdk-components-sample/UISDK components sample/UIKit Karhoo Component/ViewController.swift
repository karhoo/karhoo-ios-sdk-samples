//
//  ViewController.swift
//  DemoComponent
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import UIKit
import KarhooUISDK
import KarhooSDK
import SwiftSpinner

class ViewController: UIViewController {

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

    private lazy var background: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.6
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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

        bookingStatus.add(observer: self)
        startDemo()
    }

    /* ensure authentication before showing UI */
    private func startDemo() {
        if Karhoo.configuration.authenticationMethod().guestSettings != nil {
            self.setupView()
        } else {
            let userService = Karhoo.getUserService()

            userService.login(userLogin: UserLogin(username: "jeevan.thandi+sandboxtest@karhoo.com",
                                                   password: "12345678Aa")).execute(callback: { [weak self] result in
                                                    switch result {
                                                    case .success(_ ):
                                                        self?.setupView()
                                                    case .failure(let error):
                                                        print("error! \(String(describing: error ?? nil))")
                                                    }
                                                   })
        }
    }

    // layout component constraints
    func setupView() {
        self.view.addSubview(addressBar)
        self.view.addSubview(titleLabel)
        self.view.addSubview(background)
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


        [background.topAnchor.constraint(equalTo: view.topAnchor),
         background.bottomAnchor.constraint(equalTo: view.bottomAnchor),
         background.leftAnchor.constraint(equalTo: view.leftAnchor),
         background.rightAnchor.constraint(equalTo: view.rightAnchor)].forEach { constraint in
            constraint.isActive = true
         }

        addChild(quoteList)
        quoteListContainer.addSubview(quoteList.view)
        quoteList.view.pinEdges(to: quoteListContainer)
        quoteList.didMove(toParent: self)
    }

    // show the booking request component (which is actually a screen)
    func showQuote(quote: Quote) {
        let bookingRequestScreen = KarhooUI().screens().bookingRequest().buildBookingRequestScreen(quote: quote,
                                                                                                   bookingDetails: bookingStatus.getBookingDetails()!, callback: { result in
                                                                                                    self.handleBookedTripResult(result: result)
                                                                                                   })
        present(bookingRequestScreen, animated: true, completion: nil)
    }

    private func handleBookedTripResult(result: ScreenResult<TripInfo>) {
        if let trip = result.completedValue() {
            self.dismiss(animated: true, completion: nil)

            SwiftSpinner.show(duration: 3, title: "Allocating Driver", animated: true, completion: {
                let tripScreen = KarhooUI().screens().tripScreen().buildTripScreen(trip: trip, callback: {_ in
                    self.dismiss(animated: true, completion: nil)
                })

                self.present(tripScreen, animated: true, completion: nil)
            })

        } else {
            print("booking error", result.errorValue() ?? "")
        }
    }
}

// called when the user manipulates the pickup / drop off details in the address bar component
extension ViewController: BookingDetailsObserver {

    func bookingStateChanged(details: BookingDetails?) {
        guard let _ = details?.originLocationDetails, let _ = details?.destinationLocationDetails else {
            quoteListContainer.isHidden = true
            return
        }

        quoteListContainer.isHidden = false
    }
}

// Quote list component output
extension ViewController: QuoteListActions {
    func quotesAvailabilityDidUpdate(availability: Bool) {
        print("quotesAvailabilityDidUpdate: ", availability)
    }

    func didSelectQuote(_ quote: Quote) {
        showQuote(quote: quote)
    }
}
