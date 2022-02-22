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

protocol ComponentSamplePresenterP {
    func didLoad(view: ComponentSampleViewControllerP)
    func didSelect(quote: Quote)
}

final class ComponentSamplePresenter: ComponentSamplePresenterP {

    var view: ComponentSampleViewControllerP? = nil
    private var bookingStatus = KarhooBookingStatus.shared

    func didLoad(view: ComponentSampleViewControllerP) {
        self.view = view
        bookingStatus.add(observer: self)
        
        //Temporary bandaid until we decide how we're going to handle the analytics event triggered in the viewWillAppear of the quote list view controller
        bookingStatus.set(pickup: LocationInfo())
    }

    // QuoteList component output
    func didSelect(quote: Quote) {
        let bookingRequestScreen = KarhooUI()
            .screens()
            .checkout()
            .buildCheckoutScreen(quote: quote,
                                       bookingDetails: bookingStatus.getBookingDetails()!,
                                       bookingMetadata: nil,
                                       callback: { [weak self] result in
                                        self?.handleBookingResult(result)
                                       })
        bookingRequestScreen.modalPresentationStyle = .fullScreen
        view?.presentView(viewController: bookingRequestScreen)
    }

    // BookingRequestScreen output
    private func handleBookingResult(_ result: ScreenResult<TripInfo>) {
        if let trip = result.completedValue() {
            view?.dismissTopViewController()

            SwiftSpinner.show(duration: 10,
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
extension ComponentSamplePresenter: BookingDetailsObserver {

    func bookingStateChanged(details: BookingDetails?) {
        guard let _ = details?.originLocationDetails, let _ = details?.destinationLocationDetails else {
            view?.quoteListHidden(true)
            return
        }

        view?.quoteListHidden(false)
    }
}
