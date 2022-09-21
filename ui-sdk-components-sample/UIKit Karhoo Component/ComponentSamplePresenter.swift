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
    func didSelect(quote: Quote, journeyDetails: JourneyDetails)
    func didAppear(view: ComponentSampleViewControllerP)
}

final class ComponentSamplePresenter: ComponentSamplePresenterP {

    var isShowingQuoteList = false
    var view: ComponentSampleViewControllerP? = nil
    private var journeyDetailsManager = KarhooJourneyDetailsManager.shared

    func didLoad(view: ComponentSampleViewControllerP) {
        self.view = view
        journeyDetailsManager.add(observer: self)
        
        //Temporary bandaid until we decide how we're going to handle the analytics event triggered in the viewWillAppear of the quote list view controller
        journeyDetailsManager.set(pickup: LocationInfo())
    }

    // QuoteList component output
    func didSelect(quote: Quote, journeyDetails: JourneyDetails) {
        let bookingRequestScreen = KarhooUI()
            .screens()
            .checkout()
            .buildCheckoutScreen(
                quote: quote,
                journeyDetails: journeyDetails,
                bookingMetadata: nil,
                callback: { [weak self] result in
                    self?.handleBookingResult(result)
                })
        bookingRequestScreen.modalPresentationStyle = .fullScreen
        view?.navController?.pushViewController(bookingRequestScreen, animated: true)
        view?.navController?.title = "Checkout"
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
    
    func didAppear(view: ComponentSampleViewControllerP) {
        isShowingQuoteList = false
    }
}

// any component can listen and publish the details of a booking in progress
// the address bar component writes to this observer and the quote list listens.
extension ComponentSamplePresenter: JourneyDetailsObserver {

    func journeyDetailsChanged(details: JourneyDetails?) {
        guard let details = details,
              let _ = details.destinationLocationDetails,
              let navigationController = self.view?.navController,
              !isShowingQuoteList
        else {
            return
        }
        
        isShowingQuoteList = true
        let quoteListScreen = KarhooUI.components.quoteList(
            navigationController: navigationController,
            journeyDetails: details) { [weak self] quote, journeyDetails in
                self?.didSelect(quote: quote, journeyDetails: journeyDetails)
            }
        
        self.view?.navController?.title = "Quote List"
        quoteListScreen.start()
    }
}
