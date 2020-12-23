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
    
    func startAddCardFlow(quoteListStatus: QuoteListStatus) {
        self.selectedQuote = quoteListStatus.selectedQuote
        let sdkToken = PaymentSDKTokenPayload(organisationId: Karhoo.getUserService().getCurrentUser()?.primaryOrganisationID ?? "",
                                              currency: quoteListStatus.selectedQuote?.price.currencyCode ?? "")

        paymentsService.initialisePaymentSDK(paymentSDKTokenPayload: sdkToken).execute { result in
            if let btToken = result.successValue() {
                self.paymentsToken = btToken.token
                self.addCard()
            } else {
                //TODO Handle error
            }
        }
    }
    
    func addCard() {
        let request = BTDropInRequest()

        guard let flowItem = BTDropInController(authorization: paymentsToken,
                                                request: request,
                                                handler: {( _, result: BTDropInResult?, error: Error?) in
            if error != nil {
                //Handle error
            } else if result?.isCancelled == true {
                //Handle cancelled
            } else {
//                let paymentMethod = PaymentMethod(nonce: result!.paymentMethod!.nonce,
//                                                  nonceType: result!.paymentMethod!.type,
//                                                  icon: result!.paymentIcon,
//                                                  paymentDescription: result!.paymentDescription)
                print("ADD CARD SUCCESS")
            }
        }) else {
            return
        }
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
                self.getPaymentNonce()
            } else {
                //TODO Handle error
            }
        }
    }

    func getPaymentNonce() {
        let user = userService.getCurrentUser()
        let nonceRequest = NonceRequestPayload(payer: Payer(id: user?.userId ?? "",
                                                            firstName: user?.firstName ?? "",
                                                            lastName: user?.lastName ?? "",
                                                            email: user?.email ?? ""),
                                               organisationId: user?.primaryOrganisationID ?? "")
        
        paymentsService.getNonce(nonceRequestPayload: nonceRequest).execute { result in
            guard let nonce = result.successValue() else {
                return
            }
            self.execute3dSecureCheckOnNonce(nonce)
        }
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
    
    private func execute3dSecureCheckOnNonce(_ nonce: Nonce) {
        guard self.paymentsToken != nil else {
            //Handle error
            return
        }

        guard let quote = selectedQuote else {
            return
        }
        
        start3DSecureCheck(amount: NSDecimalNumber(value: quote.price.highPrice))
    }
    
    func threeDSecureNonce(braintreeSDKToken: String, paymentsNonce: Nonce, amount: NSDecimalNumber) {
        let request = BTThreeDSecureRequest()
        request.nonce = paymentsNonce.nonce
        request.amount = amount
        request.versionRequested = .version2
    }
    
    private func start3DSecureCheck(amount: NSDecimalNumber) {
//        guard let apiClient = BTAPIClient(authorization: authToken.token) else {
//            return
//        }
        
        guard self.paymentsToken != nil else {
            //Handle error
            return
        }

        guard let quote = selectedQuote else {
            return
        }
        
        let request = BTDropInRequest()
        request.threeDSecureVerification = true
        
        let threeDSecureRequest = BTThreeDSecureRequest()
        threeDSecureRequest.nonce = paymentNonce
        threeDSecureRequest.versionRequested = .version2
        
        let decimalNumberHandler = NSDecimalNumberHandler(roundingMode: .plain,
                                                          scale: 2,
                                                          raiseOnExactness: false,
                                                          raiseOnOverflow: false,
                                                          raiseOnUnderflow: false,
                                                          raiseOnDivideByZero: false)
        
        threeDSecureRequest.amount = amount.rounding(accordingToBehavior: decimalNumberHandler)
        
        let dropInRequest = BTDropInRequest()
        dropInRequest.threeDSecureVerification = true
        dropInRequest.threeDSecureRequest = threeDSecureRequest
        
        let dropIn = BTDropInController(authorization: paymentsToken, request: dropInRequest) { (controller, result, error) in
            if (error != nil) {
                // Handle error
                print("ERROR")
            } else if (result?.isCancelled == true) {
                // Handle user cancelled flow
                print("CANCELLED")
            } else {
                // Use the nonce returned in `result.paymentMethod`
                print("SUCCESS")
                self.bookTrip()
            }
            controller.dismiss(animated: true, completion: nil)
        }
    }
}
