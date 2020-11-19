//
//  AddressBar.swift
//  SwiftUIComponents
//
//  Created by Jeevan Thandi on 19/11/2020.
//

import SwiftUI
import KarhooUISDK

struct AddressBar: UIViewRepresentable {

    func makeUIView(context: Context) -> QuoteListView {
        return UITextView()
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }

}
