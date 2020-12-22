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
    private let tripsService: TripService = Karhoo.getTripService()
    private let paymentsService: PaymentService = Karhoo.getPaymentService()
    public let quoteListStatus: QuoteListStatus = QuoteListStatus()
    
    @Published var cardDetail: String = ""
    
    func bookTrip(quote: QuoteListStatus) {
        let tripBooking = TripBooking(quoteId: quote.selectedQuote?.id ?? "",
                                      passengers: Passengers(),
                                      flightNumber: nil,
                                      paymentNonce: nil,
                                      comments: nil)
        tripsService.book(tripBooking: tripBooking)
    }
    
    func addPayment() {
        let payer = Payer(id: "1234", firstName: "Joe", lastName: "Bloggs", email: "test.test@test.test")
        let paymentDetails = AddPaymentDetailsPayload(nonce: "", payer: payer, organisationId: "")

        getPaymentProvider()
        paymentsService.addPaymentDetails(addPaymentDetailsPayload: paymentDetails)
    }
    
    func getPaymentProvider() {
        paymentsService.getPaymentProvider()
    }

    func initSDKPayment() {
        let initSDKCallback = { (result: Result<PaymentSDKToken>) in
            switch result {
            case .success(let token):
                self.getPaymentsNonce(braintreeSDKToken: token.token)
            case .failure(let error):
                self.reportError(error: "No token found")
            }
        }

        let SDKToken = PaymentSDKTokenPayload(organisationId: Karhoo.getUserService().getCurrentUser()?.primaryOrganisationID ?? "",
                                              currency: quoteListStatus.selectedQuote?.price.currencyCode ?? "")

        paymentsService.initialisePaymentSDK(paymentSDKTokenPayload: SDKToken).execute(callback: initSDKCallback)
    }

    func getPaymentsNonce(braintreeSDKToken: String) {
        let paymentNonceCallback = { (result: Result<Nonce>) in
            switch result {
            case .success(let nonce):
                self.cardDetail = nonce.lastFour
            case .failure(let error):
                self.reportError(error: "No token found")
            }
        }

        let user = Karhoo.getUserService().getCurrentUser()
        let nonce = NonceRequestPayload(payer: Payer(id: user?.userId ?? "",
                                                     firstName: user?.firstName ?? "",
                                                     lastName: user?.lastName ?? "",
                                                     email: user?.email ?? ""),
                                        organisationId: Karhoo.getUserService().getCurrentUser()?.primaryOrganisationID ?? "")

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
        let user = Karhoo.getUserService().getCurrentUser()
        return PassengerDetails(firstName: user?.firstName ?? "",
                                lastName: user?.lastName ?? "",
                                email: user?.email ?? "",
                                phoneNumber: user?.mobileNumber ?? "",
                                locale: user?.locale ?? "")
    }
}


