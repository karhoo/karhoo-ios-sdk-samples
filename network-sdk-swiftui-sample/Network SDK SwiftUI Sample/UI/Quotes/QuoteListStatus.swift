//
//  QuoteListStatus.swift
//  Network SDK SwiftUI Sample
//
//  Created by Mostafa Hadian on 16/08/2020.
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

class QuoteListStatus: ObservableObject {
    @Published var selectedQuote: Quote?
}
