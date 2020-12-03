//
//  TripBookingModel.swift
//  Network SDK SwiftUI Sample
//
//  Created by Edward Wilkins on 02/12/2020.
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK
import Combine

class TripBookingModel: ObservableObject {
    private let tripsService: TripService = Karhoo.getTripService()
    
    func bookTrip(quoteId: String) {
        let tripBooking = TripBooking(quoteId: quoteId,
                                      passengers: Passengers(),
                                      flightNumber: nil,
                                      paymentNonce: nil,
                                      comments: nil)
        tripsService.book(tripBooking: tripBooking)
    }
}


