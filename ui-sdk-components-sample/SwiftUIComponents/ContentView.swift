//
//  ContentView.swift
//  SwiftUIComponents
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Spacer()
        AddressBar().frame(width: 400, height: 120, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).background(Color.red)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
