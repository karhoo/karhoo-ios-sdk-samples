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
import Braintree
import BraintreeDropIn

class TripBookingModel: ObservableObject {
    private let tripService: TripService = Karhoo.getTripService()
    private let paymentsService: PaymentService = Karhoo.getPaymentService()
    private let userService: UserService = Karhoo.getUserService()
    private var selectedQuote: Quote?
    
    @Published var cardDetail: String = ""
    @Published var paymentNonce: String = ""
    @Published var paymentsToken: String = ""
    
    func bookTrip() {
        let tripBooking = TripBooking(quoteId: selectedQuote?.id ?? "",
                                      passengers: Passengers(),
                                      flightNumber: nil,
                                      paymentNonce: paymentNonce,
                                      comments: nil)
        tripService.book(tripBooking: tripBooking)
            .execute(callback: { (result: Result<TripInfo>) in
                self.handleBookTrip(result: result)
            })
    }

    private func handleBookTrip(result: Result<TripInfo>) {
        guard let trip = result.successValue() else {
            if result.errorValue()?.type == .couldNotBookTripPaymentPreAuthFailed {
                //Handle error
            } else {
                print("SUCCESS")
            }
            return
        }
        print("Trip id: \(trip.tripId)")
    }
    
    func addPayment() {
        guard let user = userService.getCurrentUser() else { return }
        guard let payerOrg = user.organisations.first else {
            return
        }
        let payer = Payer(id: user.userId, firstName: user.firstName, lastName: user.lastName, email: user.email)
        let paymentDetails = AddPaymentDetailsPayload(nonce: paymentsToken, payer: payer, organisationId: payerOrg.id)

        getPaymentProvider()
        
        paymentsService.addPaymentDetails(addPaymentDetailsPayload: paymentDetails)
            .execute(callback: { result in
                guard let nonce = result.successValue() else {
                    //Handle error
                    return
                }
                self.paymentNonce = nonce.nonce
                self.bookTrip()
            })
    }
    
    func getPaymentProvider() {
        paymentsService.getPaymentProvider()
    }

    func initSDKPayment(quoteListStatus: QuoteListStatus) {
        self.selectedQuote = quoteListStatus.selectedQuote
        let sdkToken = PaymentSDKTokenPayload(organisationId: Karhoo.getUserService().getCurrentUser()?.primaryOrganisationID ?? "",
                                              currency: quoteListStatus.selectedQuote?.price.currencyCode ?? "")

        paymentsService.initialisePaymentSDK(paymentSDKTokenPayload: sdkToken).execute { result in
            if let btToken = result.successValue() {
                self.paymentsToken = btToken.token
            } else {
                //TODO Handle error
            }
        }
    }

    func getPaymentNonce(braintreeSDKToken: String) {
        let paymentNonceCallback = { (result: Result<Nonce>) in
            switch result {
            case .success(let nonce):
                self.cardDetail = nonce.lastFour
            case .failure(let error):
                self.reportError(error: "No token found")
            }
        }

        let user = userService.getCurrentUser()
        let nonce = NonceRequestPayload(payer: Payer(id: user?.userId ?? "",
                                                     firstName: user?.firstName ?? "",
                                                     lastName: user?.lastName ?? "",
                                                     email: user?.email ?? ""),
                                        organisationId: user?.primaryOrganisationID ?? "")

        paymentsService.getNonce(nonceRequestPayload: nonce).execute(callback: paymentNonceCallback)
    }
    
    func threeDSecureNone(braintreeSDKToken: String, paymentsNonce: Nonce, amount: NSDecimalNumber) {
        let request = BTThreeDSecureRequest()
        request.nonce = paymentsNonce.nonce
        request.amount = amount
        request.versionRequested = .version2
    }

    private func reportError(error: String) {
        print(error)
    }
    
    private func getPassengerDetails() -> PassengerDetails {
        let user = userService.getCurrentUser()
        return PassengerDetails(firstName: user?.firstName ?? "",
                                lastName: user?.lastName ?? "",
                                email: user?.email ?? "",
                                phoneNumber: user?.mobileNumber ?? "",
                                locale: user?.locale ?? "")
    }
}


