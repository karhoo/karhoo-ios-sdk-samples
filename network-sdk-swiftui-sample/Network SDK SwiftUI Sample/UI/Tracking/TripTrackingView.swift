//
//  TripTrackingView.swift
//  Network SDK SwiftUI Sample
//
//  Created by Mostafa Hadian on 13/08/2020.
//  Copyright © 2020 Karhoo. All rights reserved.
//

import SwiftUI

struct TripTrackingView: View {
    @Binding var tabSelection: Int
    
    public let bookingStatus: BookingStatus
    public let quoteListStatus: QuoteListStatus
    public let tripStatus: TripStatus
    
    var body: some View {
        ZStack {
            VStack {
                Text("TripTrackingView")
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
                VStack {
                    Text("Trip")
                    Text("\(self.tripStatus.tripInfo.vehicle.driver.firstName) \(self.tripStatus.tripInfo.vehicle.driver.lastName)")
                    Text("\(self.tripStatus.tripInfo.tripId)")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(red: 0.82, green: 1.00, blue: 0.99))
                .padding(10)
            }
        }
    }
}

struct TripTrackingView_Previews: PreviewProvider {
    @State static var tabSelection: Int = 4
    
    static var previews: some View {
        TripTrackingView(tabSelection: $tabSelection, bookingStatus: BookingStatus(), quoteListStatus: QuoteListStatus(), tripStatus: TripStatus())
    }
}
