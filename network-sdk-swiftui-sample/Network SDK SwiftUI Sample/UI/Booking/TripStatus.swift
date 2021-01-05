//
//  TripStatus.swift
//  Network SDK SwiftUI Sample
//
//  Created by Jo Santamaria on 05/01/2021.
//  Copyright © 2021 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

class TripStatus: ObservableObject {
    @Published var tripInfo: TripInfo = TripInfo()
}
