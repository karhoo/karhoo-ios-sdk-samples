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
    
    public let tripStatus: TripStatus
    
    var body: some View {
        ZStack {
            VStack {
                Text("TripTrackingView")
                    .font(.title)
                    .padding()
                VStack {
                    Text("Trip")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .center)
                    HStack {
                        Text("Trip id")
                            .font(.subheadline)
                            .bold()
                        Text("\(self.tripStatus.tripInfo.tripId)")
                    }
                    
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(red: 0.82, green: 1.00, blue: 0.99))
                .padding(10)
                VStack(alignment: .leading, spacing: 10) {
                    Text("Address")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .center)
                    HStack {
                        Text("Pick up")
                            .font(.subheadline)
                            .bold()
                        Text(self.tripStatus.tripInfo.origin.displayAddress)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    HStack {
                        Text("Drop off")
                            .font(.subheadline)
                            .bold()
                        Text(self.tripStatus.tripInfo.destination?.displayAddress ?? "")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(red: 0.82, green: 1.00, blue: 0.99))
                .padding(10)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 0.03, green: 0.60, blue: 0.57))
    }
}

struct TripTrackingView_Previews: PreviewProvider {
    @State static var tabSelection: Int = 4
    
    static var previews: some View {
        TripTrackingView(tabSelection: $tabSelection, tripStatus: TripStatus())
    }
}
