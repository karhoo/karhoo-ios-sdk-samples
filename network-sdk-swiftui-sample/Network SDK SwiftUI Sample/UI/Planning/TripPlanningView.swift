//
//  TripPlanningView.swift
//  Network SDK SwiftUI Sample
//
//  Created by Mostafa Hadian on 13/08/2020.
//  Copyright © 2020 Karhoo. All rights reserved.
//

import SwiftUI
import KarhooSDK

struct TripPlanningView: View {
    public let bookingStatus: BookingStatus
    
    @Binding var tabSelection: Int
    
    @State private var pickUp = ""
    @State private var dropOff = ""
    @State private var sessionToken: String = UUID().uuidString
    @State private var addressService = Karhoo.getAddressService()
    @State private var showingAlert = false
    @State private var message = ""
    @State private var places: [Place] = []
    @State private var locationsChosen = false
    
    @EnvironmentObject var quoteListStatus: QuoteListStatus
    
    var body: some View {
        ZStack {
            VStack {
                Text("Trip Planning")
                    .textStyle(TitleStyle())
                VStack {
                    HStack{
                        TextField("Pick up", text: self.$pickUp)
                            .padding()
                        Button("Submit", action: pickupPressed)
                            .buttonStyle(ActionButtonStyle())
                            .background(Color(red: 0.01, green: 0.29, blue: 0.51))
                            .cornerRadius(StyleConstants.cornerRadius)
                    }
                    HStack {
                        TextField("Drop off", text: self.$dropOff)
                            .padding()
                        Button("Submit", action: dropOffPressed)
                            .buttonStyle(ActionButtonStyle())
                            .background(Color(red: 0.01, green: 0.29, blue: 0.51))
                            .cornerRadius(StyleConstants.cornerRadius)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(red: 0.84, green: 0.90, blue: 1.00))
                .cornerRadius(StyleConstants.cornerRadius)
                VStack(alignment: .leading) {
                    Text("\(self.bookingStatus.pickup?.address.displayAddress ?? "")")
                        .textStyle(InputStyle())
                    Text("\(self.bookingStatus.destination?.address.displayAddress ?? "")")
                        .textStyle(InputStyle())
                }
                VStack {
                    Button("Get Quotes", action: getQuotes)
                        .buttonStyle(ActionButtonStyle())
                        .frame(width: 300, height: 50)
                        .background(Color(red: 0.01, green: 0.29, blue: 0.51))
                        .cornerRadius(StyleConstants.cornerRadius)
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(10)
            .background(Color(red: 0.04, green: 0.52, blue: 0.89))
        }
    }
    
    private func pickupPressed(){
        self.bookingStatus.pickup = LocationInfo()
        performSearch(string: self.pickUp, addressType: AddressType.ORIGIN)
    }
    
    private func dropOffPressed(){
        self.bookingStatus.destination = LocationInfo()
        performSearch(string: self.dropOff, addressType: AddressType.DESTINATION)
    }
    
    private func performSearch(string: String, addressType: AddressType) {
        let searchCallback = { (result: Result<Places>) in
            switch result {
            case .success(let places, _):
                self.performLocationInfo(place: places.places[0], addressType: addressType)
            case .failure(let error, _):
                self.showError(message: "Error... \(String(describing: error?.localizedDescription))")
            }
        }
        
        let placeSearch = PlaceSearch(position: Position(),
                                      query: string,
                                      sessionToken: self.sessionToken)
        self.addressService.placeSearch(placeSearch: placeSearch)
            .execute(callback: searchCallback)
    }
    
    private func performLocationInfo(place: Place, addressType: AddressType) {
        let locationInfoCallback = { (result: Result<LocationInfo>) in
            switch result {
            case .success(let locationInfo, _):
                self.searchCompleted(locationInfo: locationInfo, addressType: addressType)
            case .failure(let error, _):
                self.showError(message: "Error \(String(describing: error?.localizedDescription))")
            }
        }
        
        let placeSearch = LocationInfoSearch(placeId: place.placeId, sessionToken: self.sessionToken)
        self.addressService.locationInfo(locationInfoSearch: placeSearch)
            .execute(callback: locationInfoCallback)
    }
    
    private func searchCompleted(locationInfo: LocationInfo, addressType: AddressType) {
        if (addressType == AddressType.ORIGIN) {
            bookingStatus.pickup = locationInfo
        } else {
            bookingStatus.destination = locationInfo
        }
    }
    
    private func getQuotes() {
        if(!pickUp.isEmpty && !dropOff.isEmpty) {
            self.tabSelection = 2
        } else {
            self.showError(message: "Choose an origin and destination")
        }
    }
    
    private func showError(message: String) {
        self.showingAlert = true
        self.message = message
    }
}

struct TripPlanningView_Previews: PreviewProvider {
    @State static var tabSelection: Int = 1
    
    static var previews: some View {
        TripPlanningView(bookingStatus: BookingStatus(), tabSelection: $tabSelection)
    }
}
