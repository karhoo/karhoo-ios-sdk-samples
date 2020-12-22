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
    private let userService: UserService = Karhoo.getUserService()
    
    @Published var cardDetail: String = ""
    
    func bookTrip(quoteListStatus: QuoteListStatus) {
        initSDKPayment(quoteListStatus: quoteListStatus)
        let tripBooking = TripBooking(quoteId: quoteListStatus.selectedQuote?.id ?? "",
                                      passengers: Passengers(),
                                      flightNumber: nil,
                                      paymentNonce: nil,
                                      comments: nil)
        tripsService.book(tripBooking: tripBooking)
    }
    
    func addPayment() {
        guard let user = userService.getCurrentUser() else { return }
        let payer = Payer(id: user.userId, firstName: user.firstName, lastName: user.lastName, email: user.email)
        let paymentDetails = AddPaymentDetailsPayload(nonce: "", payer: payer, organisationId: "")

        getPaymentProvider()
        paymentsService.addPaymentDetails(addPaymentDetailsPayload: paymentDetails)
    }
    
    func getPaymentProvider() {
        paymentsService.getPaymentProvider()
    }

    func initSDKPayment(quoteListStatus: QuoteListStatus) {
        let sdkToken = PaymentSDKTokenPayload(organisationId: Karhoo.getUserService().getCurrentUser()?.primaryOrganisationID ?? "",
                                              currency: quoteListStatus.selectedQuote?.price.currencyCode ?? "")

        paymentsService.initialisePaymentSDK(paymentSDKTokenPayload: sdkToken).execute { [weak self] result in
            if let token = result.successValue() {
                self?.buildBraintreeUI(paymentsToken: token)
            } else {
                //TODO Handle error
            }
        }
    }
    
    func buildBraintreeUI(paymentsToken: PaymentSDKToken) {
        
        let request =  BTDropInRequest()
        let dropIn = BTDropInController(authorization: paymentsToken.token, request: request)
            { (controller, result, error) in
                if (error != nil) {
                    print("ERROR")
                } else if (result?.isCancelled == true) {
                    print("CANCELLED")
                } else if let result = result {
                    print("RESULT \(result.paymentMethod!.nonce)")
                }
                controller.dismiss(animated: true, completion: nil)
            }
        print("PRESENT")
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


