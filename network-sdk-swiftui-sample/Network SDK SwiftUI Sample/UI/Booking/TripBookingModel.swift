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

class TripBookingModel: NSObject, ObservableObject, BTViewControllerPresentingDelegate {
    private let tripService: TripService = Karhoo.getTripService()
    private let paymentsService: PaymentService = Karhoo.getPaymentService()
    private var paymentFlowDriver: BTPaymentFlowDriver?
    private let userService: UserService = Karhoo.getUserService()
    private var selectedQuote: Quote?
    
    @Published var cardDetail: String = ""
    @Published var paymentNonce: String = ""
    @Published var paymentsToken: String = ""
    
    func bookTrip() {
        let tripBooking = TripBooking(quoteId: selectedQuote?.id ?? "",
                                      passengers: Passengers(additionalPassengers: 0,
                                                             passengerDetails: [getPassengerDetails()]),
                                      flightNumber: nil,
                                      paymentNonce: paymentNonce,
                                      comments: nil)
        tripService.book(tripBooking: tripBooking)
            .execute(callback: { (result: Result<TripInfo>) in
                self.handleBookTrip(result: result)
            })
    }
    
    private func getPassengerDetails() -> PassengerDetails {
        let user = userService.getCurrentUser()
        return PassengerDetails(firstName: user?.firstName ?? "",
                                lastName: user?.lastName ?? "",
                                email: user?.email ?? "",
                                phoneNumber: user?.mobileNumber ?? "",
                                locale: user?.locale ?? "")
    }

    private func handleBookTrip(result: Result<TripInfo>) {
        guard let trip = result.successValue() else {
            if result.errorValue()?.type == .couldNotBookTripPaymentPreAuthFailed {
                //Handle error
            } else {
                print("SUCCESS \(result.successValue()?.tripId)")
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
            } else {
                //TODO Handle error
            }
        }
    }
    
    func addCard(nonce: String) {
        guard let currentUser = userService.getCurrentUser() else {
            return
        }

        let payer = Payer(id: currentUser.userId,
                          firstName: currentUser.firstName,
                          lastName: currentUser.lastName,
                          email: currentUser.email)

        guard let payerOrg = currentUser.organisations.first else {
            return
        }

        let addPaymentPayload = AddPaymentDetailsPayload(nonce: nonce,
                                                         payer: payer,
                                                         organisationId: payerOrg.id)

        paymentsService.addPaymentDetails(addPaymentDetailsPayload: addPaymentPayload)
            .execute(callback: { result in
                guard let nonce = result.successValue() else {
                    //Handle error
                    return
                }
                print("SUCCESS ADD CARD \(nonce)")
            })
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
            self.paymentNonce = nonce.nonce
            self.execute3dSecureCheckOnNonce(nonce)
        }
    }

    private func reportError(error: String) {
        print(error)
    }
    
    private func execute3dSecureCheckOnNonce(_ nonce: Nonce) {
        guard self.paymentsToken != "" else {
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
        guard let apiClient = BTAPIClient(authorization: paymentsToken) else {
            return
        }
        
        self.paymentFlowDriver = BTPaymentFlowDriver(apiClient: apiClient)
        self.paymentFlowDriver?.viewControllerPresentingDelegate = self
        
        guard self.paymentsToken != "" else {
            //Handle error
            return
        }

        guard self.selectedQuote != nil else {
            return
        }
        
        let request = BTThreeDSecureRequest()
        request.nonce = paymentNonce
        request.versionRequested = .version2
        request.threeDSecureRequestDelegate = self

        let decimalNumberHandler = NSDecimalNumberHandler(roundingMode: .plain,
                                                          scale: 2,
                                                          raiseOnExactness: false,
                                                          raiseOnOverflow: false,
                                                          raiseOnUnderflow: false,
                                                          raiseOnDivideByZero: false)
        
        request.amount = amount.rounding(accordingToBehavior: decimalNumberHandler)
        
        self.paymentFlowDriver?.startPaymentFlow(request) { [weak self] (result, error) in
            if error?._code == BTPaymentFlowDriverErrorType.canceled.rawValue {
                //Handle cancellation
                return
            }

            guard let result = result as? BTThreeDSecureResult else {
                //Handle result
                print("3DS ERROR")
                return
            }
            
            self?.threeDSecureResponseHandler(result: result)
        }
    }
    
    func paymentDriver(_ driver: Any, requestsDismissalOf viewController: UIViewController) {
        //present
    }
    
    func paymentDriver(_ driver: Any, requestsPresentationOf viewController: UIViewController) {
        //dismiss
    }
}

extension TripBookingModel: BTThreeDSecureRequestDelegate {
    
    func onLookupComplete(_ request: BTThreeDSecureRequest,
                          result: BTThreeDSecureLookup,
                          next: @escaping () -> Void) {
        next()
    }

    private func threeDSecureResponseHandler(result: BTThreeDSecureResult) {
        if result.tokenizedCard.nonce != "" {
            self.paymentNonce = result.tokenizedCard.nonce
            bookTrip()
        } else {
            print("3DS AUTH ERROR")
            //Handle error
        }
    }
}
