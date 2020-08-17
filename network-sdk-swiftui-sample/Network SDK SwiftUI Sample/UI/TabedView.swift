//
//  TabedView.swift
//  Network SDK SwiftUI Sample
//
//  Created by Mostafa Hadian on 13/08/2020.
//  Copyright © 2020 Karhoo. All rights reserved.
//

import SwiftUI
import KarhooSDK

struct TabedView : View {
    @State private var selectedTab = 0
    
    @EnvironmentObject var bookingStatus: BookingStatus
    @EnvironmentObject var quoteListStatus: QuoteListStatus
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ConfigurationView()
                .tabItem {
                    Image(systemName: "lock.shield")
                        .font(.system(size: 22))
            }
            .tag(0)
            
            TripPlanningView(bookingStatus: bookingStatus)
                .tabItem {
                    Image(systemName: "square.and.pencil")
                        .font(.system(size: 22))
            }
            .tag(1)
            
            TripQuotesView(bookingStatus: bookingStatus, quoteListStatus: quoteListStatus )
                .tabItem {
                    Image(systemName: "list.bullet")
                        .font(.system(size: 22))
            }
            .tag(2)
            
            TripBookingView(bookingStatus: bookingStatus, quoteListStatus: quoteListStatus)
                .tabItem {
                    Image(systemName: "cart.fill")
                        .font(.system(size: 22))
            }
            .tag(3)
            
            TripTrackingView()
                .tabItem {
                    Image(systemName: "location.north.line.fill")
                        .font(.system(size: 22))
            }
            .tag(4)
        }
        .accentColor(.black)
    }
}

struct TabedView_Previews: PreviewProvider {
    static var previews: some View {
        TabedView()
    }
}
