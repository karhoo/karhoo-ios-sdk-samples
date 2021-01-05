//
//  TripTrackingView.swift
//  Network SDK SwiftUI Sample
//
//  Created by Mostafa Hadian on 13/08/2020.
//  Copyright © 2020 Karhoo. All rights reserved.
//

import SwiftUI

struct TripTrackingView: View {
    @Binding var tabSelection: Int
    
    var body: some View {
        Text("TripTrackingView")
    }
}

struct TripTrackingView_Previews: PreviewProvider {
    @State static var tabSelection: Int = 4
    
    static var previews: some View {
        TripTrackingView(tabSelection: $tabSelection)
    }
}
