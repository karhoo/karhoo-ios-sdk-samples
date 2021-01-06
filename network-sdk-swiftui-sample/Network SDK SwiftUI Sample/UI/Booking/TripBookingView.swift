//
//  TripBookingView.swift
//  Network SDK SwiftUI Sample
//
//  Created by Mostafa Hadian on 13/08/2020.
//  Copyright © 2020 Karhoo. All rights reserved.
//

import SwiftUI
import Braintree
import BraintreeDropIn
import KarhooSDK

struct TripBookingView: View {
    @Binding var tabSelection: Int
    
    public let bookingStatus: BookingStatus
    public let quoteListStatus: QuoteListStatus
    public let tripStatus: TripStatus
    
    @ObservedObject var viewModel = TripBookingModel()
    
    @State var showDropIn = false
    @State var cardDetail: String = "card ending \(Karhoo.getUserService().getCurrentUser()?.nonce?.lastFour ?? "")"
    
    var body: some View {
        ZStack {
            VStack {
                Text("Trip Booking")
                    .textStyle(TitleStyle())
                VStack(alignment: .leading, spacing: 10) {
                    Text("Address")
                        .bold()
                        .textStyle(HeadlineStyle())
                    HStack {
                        Text("Pick up")
                            .bold()
                            .textStyle(SubHeadlineStyle())
                        Text(self.bookingStatus.pickup?.address.displayAddress ?? "")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    HStack {
                        Text("Drop off")
                            .bold()
                            .textStyle(SubHeadlineStyle())
                        Text(self.bookingStatus.destination?.address.displayAddress ?? "")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(red: 0.82, green: 1.00, blue: 0.99))
                .cornerRadius(StyleConstants.cornerRadius)
                .padding(.bottom, 10)
                VStack(alignment: .leading, spacing: 10) {
                    Text("Fleet")
                        .textStyle(HeadlineStyle())
                    HStack {
                        Text("Fleet name")
                            .bold()
                            .textStyle(SubHeadlineStyle())
                        Text(self.quoteListStatus.selectedQuote?.fleet.name ?? "")
                        Spacer()
                        Text("\(self.quoteListStatus.selectedQuote?.price.currencyCode ?? "") \(self.quoteListStatus.selectedQuote?.price.highPrice ?? 0)" )
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    HStack {
                        Text("Quote ID")
                            .font(.subheadline)
                            .bold()
                        Text(self.quoteListStatus.selectedQuote?.id ?? "")
                            .lineLimit(1)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(red: 0.82, green: 1.00, blue: 0.99))
                .cornerRadius(StyleConstants.cornerRadius)
                .padding(.bottom, 10)
                VStack(alignment: .leading, spacing: 10) {
                    Text("Payment Details")
                        .textStyle(HeadlineStyle())
                    HStack {
                        Text("Payment")
                            .bold()
                            .textStyle(SubHeadlineStyle())
                        Text("\(self.cardDetail)")
                        Spacer()
                        Button("Change", action: changeCard)
                            .buttonStyle(ActionButtonStyle())
                            .frame(width: 100, height: 50)
                            .background(Color(red: 0.01, green: 0.39, blue: 0.37))
                            .cornerRadius(StyleConstants.cornerRadius)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(red: 0.82, green: 1.00, blue: 0.99))
                .cornerRadius(StyleConstants.cornerRadius)
                .padding(.bottom, 10)
                Button("Book", action: bookTrip)
                    .buttonStyle(ActionButtonStyle())
                    .frame(width: 200, height: 50)
                    .background(Color(red: 0.01, green: 0.39, blue: 0.37))
                    .cornerRadius(StyleConstants.cornerRadius)
                Spacer()
            }
            if viewModel.paymentsToken != "" && self.showDropIn {
                BTDropInRepresentable(authorization: viewModel.paymentsToken, handler:  { (controller, result, error) in
                    if (error != nil) {
                        //Handle error
                        print("Payment error")
                    } else if (result?.isCancelled == true) {
                        print("Payment error")
                    } else if result != nil {
                        self.showDropIn = false
                        self.cardDetail = result!.paymentDescription
                        viewModel.addCard(nonce: result!.paymentMethod!.nonce)
                        print("SUCCESS \(result!.paymentDescription) \(result!.paymentMethod?.type ?? "no payment type")")
                    }
                    controller.dismiss(animated: true, completion: nil)
                }).edgesIgnoringSafeArea(.vertical)
            }
        }
        .onReceive(viewModel.$trip, perform: { trip in
            if(!trip.tripId.isEmpty) {
                self.tripStatus.tripInfo = trip
                self.tabSelection = 4
            }
        })
        .padding(10)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 0.03, green: 0.60, blue: 0.57))
    }
    
    private func changeCard() {
        self.showDropIn = true
        viewModel.startAddCardFlow(quoteListStatus: quoteListStatus)
    }
    
    private func bookTrip() {
        viewModel.initSDKPayment(quoteListStatus: quoteListStatus)
    }
}

struct TripBookingView_Previews: PreviewProvider {
    @State static var tabSelection: Int = 3
    
    static var previews: some View {
        TripBookingView(tabSelection: $tabSelection, bookingStatus: BookingStatus(), quoteListStatus: QuoteListStatus(), tripStatus: TripStatus())
    }
}
