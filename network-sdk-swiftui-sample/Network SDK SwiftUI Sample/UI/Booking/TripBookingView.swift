//
//  TripBookingView.swift
//  Network SDK SwiftUI Sample
//
//  Created by Mostafa Hadian on 13/08/2020.
//  Copyright © 2020 Karhoo. All rights reserved.
//

import SwiftUI

struct TripBookingView: View {
    public let bookingStatus: BookingStatus
    public let quoteListStatus: QuoteListStatus
    
    @ObservedObject var viewModel = TripBookingModel()
    
    init(bookingStatus: BookingStatus, quoteListStatus: QuoteListStatus) {
        self.bookingStatus = bookingStatus
        self.quoteListStatus = quoteListStatus
    }
    
    var body: some View {
        ZStack {
            VStack {
                Text("Trip Booking")
                    .font(.title)
                    .padding()
                VStack(alignment: .leading, spacing: 10) {
                    Text("Address")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .center)
                    HStack {
                        Text("Pick up")
                            .font(.subheadline)
                            .bold()
                        Text(self.bookingStatus.pickup?.address.displayAddress ?? "")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    HStack {
                        Text("Drop off")
                            .font(.subheadline)
                            .bold()
                        Text(self.bookingStatus.destination?.address.displayAddress ?? "")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(red: 0.82, green: 1.00, blue: 0.99))
                .padding(10)
                VStack(alignment: .leading, spacing: 10) {
                    Text("Fleet")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .center)
                    HStack {
                        Text("Fleet name")
                            .font(.subheadline)
                            .bold()
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
                .padding(10)
                VStack(alignment: .leading, spacing: 10) {
                    Text("Payment Details")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .center)
                    HStack {
                        Text("Payment")
                            .font(.subheadline)
                            .bold()
                        Text("...")
                        Spacer()
                        Button("Change", action: {})
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(red: 0.82, green: 1.00, blue: 0.99))
                .padding(10)
                Button(action: bookTrip) {
                    Text("Book")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 200, height: 50)
                        .background(Color(red: 0.01, green: 0.39, blue: 0.37))
                        .cornerRadius(15.0)
                }
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 0.03, green: 0.60, blue: 0.57))
    }
    private func bookTrip() {
        viewModel.bookTrip(quoteId: quoteListStatus.selectedQuote?.id ?? "")
    }
    
    private func addPayment() {
        viewModel.addPayment()
    }
}

struct TripBookingView_Previews: PreviewProvider {
    static var previews: some View {
        TripBookingView(bookingStatus: BookingStatus(), quoteListStatus: QuoteListStatus())
    }
}
