//
//  QuotesListModel.swift
//  Network SDK SwiftUI Sample
//
//  Created by Mostafa Hadian on 16/08/2020.
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK
import Combine

class QuotesListModel: ObservableObject {
    private let quoteService: QuoteService = Karhoo.getQuoteService()
    private var quoteSearchObservable: Observable<Quotes>?
    private lazy var quotesObserver: Observer<Quotes>? = Observer<Quotes> { result in
        switch result {
        case .success(let quotes, _):
            self.quotes = quotes.all
            
        case .failure(let error):
            print("Error \(String(describing: error))")
        }
    }
    
    @Published private(set) var quotes: [Quote] = []
    
    func retrieveQuotes(bookingStatus: BookingStatus) {
        if let qo = quotesObserver {
            quoteSearchObservable?.unsubscribe(observer: qo)
        }
        
        guard let destination = bookingStatus.destination,
            let origin = bookingStatus.pickup else {
                return
        }
        
        let quoteSearch = QuoteSearch(origin: origin,
                                      destination: destination,
                                      dateScheduled: nil)
        
        
        self.quoteSearchObservable = self.quoteService.quotes(quoteSearch: quoteSearch).observable()
        if let qo = quotesObserver {
            self.quoteSearchObservable?.subscribe(observer: qo)
        }
        
    }
    
    func stop() {
        if let qo = quotesObserver {
            quoteSearchObservable?.unsubscribe(observer: qo)
        }
    }
}
