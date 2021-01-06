//
//  TripQuotesView.swift
//  Network SDK SwiftUI Sample
//
//  Created by Mostafa Hadian on 13/08/2020.
//  Copyright © 2020 Karhoo. All rights reserved.
//

import SwiftUI
import KarhooSDK

struct TripQuotesView: View {
    @Binding var tabSelection: Int
    
    public let bookingStatus: BookingStatus
    public let quoteListStatus: QuoteListStatus
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    @ObservedObject var viewModel = QuotesListModel()
    
    var body: some View {
        ZStack {
            VStack {
                Text("Quotes")
                    .textStyle(TitleStyle())
                VStack {
                    HStack {
                        Button(action: retrieveQuotes ) {
                            Text("Retrieve Quotes")
                        }
                        .buttonStyle(ActionButtonStyle())
                        .background(Color(red: 0.04, green: 0.24, blue: 0.38))
                        .cornerRadius(15.0)
                        Button("Stop", action: stopRequest)
                            .buttonStyle(ActionButtonStyle())
                            .background(Color(red: 0.04, green: 0.24, blue: 0.38))
                            .cornerRadius(15.0)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(red: 0.82, green: 0.94, blue: 1.00))
                List(viewModel.quotes, id: \.id) { quote in
                    Text(quote.fleet.name)
                        .padding(.leading, 5)
                        .padding(.trailing, 5)
                        .onTapGesture {
                            self.tabSelection = 3
                            self.quoteListStatus.selectedQuote = quote
                        }
                }
                .listStyle(GroupedListStyle())
                .padding(10)
            }
        }
        .onAppear(perform: {
            retrieveQuotes()
        })
        .onDisappear(perform: {
            self.timer.upstream.connect().cancel()
        })
        .onReceive(timer, perform: { _ in
            retrieveQuotes()
        })
        .padding(10)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 0.39, green: 0.67, blue: 0.78))
    }
    
    private func retrieveQuotes(){
        viewModel.retrieveQuotes(bookingStatus: self.bookingStatus)
    }
    
    private func stopRequest(){
        viewModel.stop()
    }
}

struct TripQuotesView_Previews: PreviewProvider {
    @State static var tabSelection: Int = 2
    
    static var previews: some View {
        TripQuotesView(tabSelection: $tabSelection, bookingStatus: BookingStatus(), quoteListStatus: QuoteListStatus())
    }
}
