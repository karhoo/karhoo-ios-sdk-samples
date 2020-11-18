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

    private lazy var addressBar: AddressBarView = {
        let addressBar = KarhooUI.components.addressBar(journeyInfo: nil)
        addressBar.translatesAutoresizingMaskIntoConstraints = false
        return addressBar
    }()

    private lazy var quoteList: QuoteListView = {
        let quoteList = KarhooUI.components.quoteList()
        return quoteList
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
        label.text = "Get the cheapest and fastest quote!"
        label.font = UIFont(name: "Roboto", size: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var bookingStatus = KarhooBookingStatus.shared
    private var observer: Observer<Quotes>?
    private var cheapestFastestQuote: Quote?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        bookingStatus.add(observer: self)
        if Karhoo.configuration.authenticationMethod().guestSettings != nil {
            self.setupView()
        } else {
            let userService = Karhoo.getUserService()

            userService.login(userLogin: UserLogin(username: "jeevan.thandi+sandboxtest@karhoo.com",
                                                   password: "12345678Aa")).execute(callback: { [weak self]
                                                    result in
                                                    switch result {
                                                    case .success(_ ):
                                                        self?.setupView()
                                                    case .failure(let error):
                                                        print("error! \(error ?? nil)")
                                                    }
                                                   })
        }
    }

    func setupView() {
        self.view.addSubview(addressBar)
        self.view.addSubview(titleLabel)
        self.view.addSubview(background)

        [addressBar.centerYAnchor.constraint(equalTo: view.centerYAnchor),
         addressBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
         addressBar.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
         addressBar.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
         addressBar.heightAnchor.constraint(greaterThanOrEqualToConstant: 100)].forEach { constraint in
            constraint.isActive = true
         }

        [background.topAnchor.constraint(equalTo: view.topAnchor),
         background.bottomAnchor.constraint(equalTo: view.bottomAnchor),
         background.leftAnchor.constraint(equalTo: view.leftAnchor),
         background.rightAnchor.constraint(equalTo: view.rightAnchor)].forEach { constraint in
            constraint.isActive = true
         }

        [titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
         titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0)].forEach { constraint in
            constraint.isActive = true
         }
    }

    func showQuote() {
        let bookingRequestScreen = KarhooUI().screens().bookingRequest().buildBookingRequestScreen(quote: cheapestFastestQuote!,
                                                                                                   bookingDetails: bookingStatus.getBookingDetails()!, callback: { result in
                                                                                                    self.handleBookedTripResult(result: result)
                                                                                                   })

        background.isHidden = false
        present(bookingRequestScreen, animated: true, completion: nil)
    }

    private func handleBookedTripResult(result: ScreenResult<TripInfo>) {
        self.background.isHidden = true

        if let trip = result.completedValue() {
            self.dismiss(animated: true, completion: nil)

            SwiftSpinner.show(duration: 10, title: "Allocating Driver", animated: true, completion: {
                let tripScreen = KarhooUI().screens().tripScreen().buildTripScreen(trip: trip, callback: {_ in
                    self.dismiss(animated: true, completion: nil)
                })

                self.present(tripScreen, animated: true, completion: nil)
            })

        } else {
            print("booking error", result.errorValue() ?? "")
        }

    }
    func pollQuotes(origin: LocationInfo, destination: LocationInfo, date: Date?) {
        let quoteService = Karhoo.getQuoteService()

        SwiftSpinner.show(duration: 10, title: "Looking for a ride", animated: true, completion: {
            self.showQuote()
        })

        let quotesObserver = quoteService.quotes(quoteSearch: QuoteSearch(origin: origin,
                                                                          destination: destination,
                                                                          dateScheduled: date)).observable()

        observer = Observer<Quotes> { [weak self] result in
            switch result {
            case .success(let quotes):
                print("Quotes: \(quotes.all)")
                if quotes.all.isEmpty {
                    return
                }
                var allQuotes = quotes.all
                allQuotes.sort {
                    $0.price.highPrice < $1.price.lowPrice
                }

                self?.cheapestFastestQuote = allQuotes[0]

            case .failure(let error): print("Quote error! \(String(describing: error ?? nil))")
                // handle error (KarhooError)
                SwiftSpinner.hide()
            }
        }

        quotesObserver.subscribe(observer: observer!)

    }
}

extension ViewController: BookingDetailsObserver {

    func bookingStateChanged(details: BookingDetails?) {
        guard let origin = details?.originLocationDetails, let destination = details?.destinationLocationDetails else {
            return
        }
        pollQuotes(origin: origin, destination: destination, date: details?.scheduledDate)
    }
}

