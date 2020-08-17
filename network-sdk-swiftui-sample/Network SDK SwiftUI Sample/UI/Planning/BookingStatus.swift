//
//  BookingPlan.swift
//  Network SDK SwiftUI Sample
//
//  Created by Mostafa Hadian on 13/08/2020.
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

class BookingStatus: ObservableObject {
    @Published var pickup: LocationInfo? = LocationInfo()
    @Published var destination: LocationInfo? = LocationInfo()
}
