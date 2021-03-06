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
        ZStack(alignment: .top) {
            VStack {
                Text("Trip Tracking")
                    .textStyle(TitleStyle())
                VStack(alignment: .leading, spacing: 10) {
                    Text("Trip")
                        .textStyle(HeadlineStyle())
                        .frame(maxWidth: .infinity, alignment: .center)
                    HStack {
                        Text("Trip id")
                            .bold()
                            .textStyle(SubHeadlineStyle())
                        Text("\(self.tripStatus.tripInfo.tripId)")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    HStack {
                        Text("Driver")
                            .bold()
                            .textStyle(SubHeadlineStyle())
                        Text("\(self.tripStatus.tripInfo.vehicle.driver.firstName) \(self.tripStatus.tripInfo.vehicle.driver.lastName)")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    HStack {
                        Text("License number")
                            .bold()
                            .textStyle(SubHeadlineStyle())
                        Text("\(self.tripStatus.tripInfo.vehicle.vehicleLicensePlate)")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    HStack {
                        Text("Status")
                            .bold()
                            .textStyle(SubHeadlineStyle())
                        Text("\(self.tripStatus.tripInfo.state.rawValue)")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(red: 0.78, green: 0.90, blue: 1.00))
                .cornerRadius(StyleConstants.cornerRadius)
                .padding(.bottom, 10)
                VStack(alignment: .leading, spacing: 10) {
                    Text("Address")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .center)
                    HStack {
                        Text("Pick up")
                            .bold()
                            .textStyle(SubHeadlineStyle())
                        Text(self.tripStatus.tripInfo.origin.displayAddress)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    HStack {
                        Text("Drop off")
                            .bold()
                            .textStyle(SubHeadlineStyle())
                        Text(self.tripStatus.tripInfo.destination?.displayAddress ?? "")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(red: 0.78, green: 0.90, blue: 1.00))
                .cornerRadius(StyleConstants.cornerRadius)
                Spacer()
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
        .padding(10)
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
