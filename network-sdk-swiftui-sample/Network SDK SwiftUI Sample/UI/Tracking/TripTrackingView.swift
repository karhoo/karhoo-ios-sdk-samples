//
//  TripTrackingView.swift
//  Network SDK SwiftUI Sample
//
//  Created by Mostafa Hadian on 13/08/2020.
//  Copyright © 2020 Karhoo. All rights reserved.
//

import SwiftUI
import KarhooSDK

struct TripTrackingView: View {
    @Binding var tabSelection: Int
    
    public let tripStatus: TripStatus
    public let tripService: TripService = Karhoo.getTripService()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            VStack {
                Text("Trip Tracking")
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
                    HStack {
                        Text("Driver")
                            .font(.subheadline)
                            .bold()
                        Text("\(self.tripStatus.tripInfo.vehicle.driver.firstName) \(self.tripStatus.tripInfo.vehicle.driver.lastName)")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    HStack {
                        Text("License number")
                            .font(.subheadline)
                            .bold()
                        Text("\(self.tripStatus.tripInfo.vehicle.vehicleLicensePlate)")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    HStack {
                        Text("Status")
                            .font(.subheadline)
                            .bold()
                        Text("\(self.tripStatus.tripInfo.state.rawValue)")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(red: 0.78, green: 0.90, blue: 1.00))
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
                .background(Color(red: 0.78, green: 0.90, blue: 1.00))
                .padding(10)
            }
        }
        .onAppear(perform: {
            trackTrip()
        })
        .onDisappear(perform: {
            self.timer.upstream.connect().cancel()
        })
        .onReceive(timer, perform: { _ in
            trackTrip()
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 0.16, green: 0.50, blue: 0.72))
    }
    
    private func trackTrip() {
        tripService.trackTrip(identifier: self.tripStatus.tripInfo.tripId)
            .execute(callback: { (result: Result<TripInfo>) in
                self.handleTrackTrip(result: result)
            })
    }
    
    private func handleTrackTrip(result: Result<TripInfo>) {
        guard let trip = result.successValue() else {
            //Handle error
            return
        }
        tripStatus.tripInfo = trip
    }
}

struct TripTrackingView_Previews: PreviewProvider {
    @State static var tabSelection: Int = 4
    
    static var previews: some View {
        TripTrackingView(tabSelection: $tabSelection, tripStatus: TripStatus())
    }
}
