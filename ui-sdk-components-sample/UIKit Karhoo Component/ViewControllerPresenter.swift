//
//  ViewControllerPresenter.swift
//  UIKit Karhoo Component
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooUISDK
import KarhooSDK
import SwiftSpinner

protocol SampleViewControllerPresenter {
    func didLoad(view: SampleView)
    func didSelect(quote: Quote)
}

final class ViewControllerPresenter: SampleViewControllerPresenter {

    var view: SampleView? = nil
    private var bookingStatus = KarhooBookingStatus.shared

    func didLoad(view: SampleView) {
        self.view = view
        bookingStatus.add(observer: self)
        authenticateAndStartDemo()
    }

    /* ensure authentication before showing UI */
    private func authenticateAndStartDemo() {
        if Karhoo.configuration.authenticationMethod().guestSettings != nil {
            view?.setUpView()
        } else {
            let userService = Karhoo.getUserService()

            userService.login(userLogin: Keys.userLogin).execute(callback: { [weak self] result in
                                                    switch result {
                                                    case .success(_ ):
                                                        self?.view?.setUpView()
                                                    case .failure(let error):
                                                        print("error! \(String(describing: error ?? nil))")
                                                    }
                                                   })
        }
    }

    // QuoteList component output
    func didSelect(quote: Quote) {
        let bookingRequestScreen = KarhooUI()
            .screens()
            .bookingRequest()
            .buildBookingRequestScreen(quote: quote,
                                       bookingDetails: bookingStatus.getBookingDetails()!,
                                       callback: { [weak self] result in
                                        self?.handleBookingResult(result)
                                       })
        view?.presentView(viewController: bookingRequestScreen)
    }

    // BookingRequestScreen output
    private func handleBookingResult(_ result: ScreenResult<TripInfo>) {
        if let trip = result.completedValue() {
            view?.dismissTopViewController()

            SwiftSpinner.show(duration: 3,
                              title: "Allocating Driver",
                              animated: true,
                              completion: {
                let tripScreen = KarhooUI()
                    .screens()
                    .tripScreen()
                    .buildTripScreen(trip: trip,
                                     callback: { [weak self] _ in
                    self?.view?.dismissTopViewController()
                })
                self.view?.presentView(viewController: tripScreen)
            })

        } else {
            print("booking error", result.errorValue() ?? "")
        }
    }
}

// any component can listen and publish the details of a booking in progress
// the address bar component writes to this observer and the quote list listens.
extension ViewControllerPresenter: BookingDetailsObserver {

    func bookingStateChanged(details: BookingDetails?) {
        guard let _ = details?.originLocationDetails, let _ = details?.destinationLocationDetails else {
            view?.quoteListHidden(true)
            return
        }

        view?.quoteListHidden(false)
    }
}
