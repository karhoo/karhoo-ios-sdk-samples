//
//  ContentView.swift
//  SwiftUIComponents
//
//  Created by Jeevan Thandi on 19/11/2020.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        AddressBar().frame(width: 400, height: 120, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).background(Color.red)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
