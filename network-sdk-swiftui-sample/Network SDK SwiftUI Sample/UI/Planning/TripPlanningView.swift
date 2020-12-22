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
    
    @State private var pickUp = ""
    @State private var dropOff = ""
    @State private var sessionToken: String = UUID().uuidString
    @State private var addressService = Karhoo.getAddressService()
    @State private var showingAlert = false
    @State private var message = ""
    @State private var places: [Place] = []
    
    init(bookingStatus: BookingStatus) {
        self.bookingStatus = bookingStatus
    }
    
    var body: some View {
        ZStack {
            VStack {
                Text("Trip Planning")
                    .font(.title)
                    .padding()
                VStack {
                    HStack{
                        TextField("Pick up", text: self.$pickUp)
                            .padding(10)
                            .cornerRadius(20.0)
                        Button(action: pickupPressed ) {
                            Text("Submit")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(height: 40)
                                .background(Color(red: 0.01, green: 0.29, blue: 0.51))
                                .cornerRadius(15.0)
                        }
                    }
                    HStack {
                        TextField("Drop off", text: self.$dropOff)
                            .padding(10)
                            .cornerRadius(20.0)
                        Button(action: dropOffPressed ) {
                            Text("Submit")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(height: 40)
                                .background(Color(red: 0.01, green: 0.29, blue: 0.51))
                                .cornerRadius(15.0)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(red: 0.84, green: 0.90, blue: 1.00))
                .padding(10)
                VStack(alignment: .leading) {
                    Text("\(self.bookingStatus.pickup?.address.displayAddress ?? "")")
                        .font(.headline)
                        .foregroundColor(.white)
                        .lineLimit(2)
                        .padding()
                        .cornerRadius(15.0)
                    Text("\(self.bookingStatus.destination?.address.displayAddress ?? "")")
                        .font(.headline)
                        .foregroundColor(.white)
                        .lineLimit(2)
                        .padding()
                        .cornerRadius(15.0)
                }
                Spacer()
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Sample App"), message: Text(self.message), dismissButton: .default(Text("Got it!")))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
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
            case .success(let places):
                self.performLocationInfo(place: places.places[0], addressType: addressType)
            case .failure(let error):
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
            case .success(let locationInfo):
                self.searchCompleted(locationInfo: locationInfo, addressType: addressType)
            case .failure(let error):
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
    
    private func showError(message: String) {
        self.showingAlert = true
        self.message = message
    }
    
}

struct TripPlanningView_Previews: PreviewProvider {
    static var previews: some View {
        TripPlanningView(bookingStatus: BookingStatus())
    }
}
