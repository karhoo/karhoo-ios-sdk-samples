//
//  AddressBar.swift
//  SwiftUIComponents
//
//  Created by Jeevan Thandi on 19/11/2020.
//

import SwiftUI
import KarhooUISDK

struct AddressBar: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let addressBar = KarhooUI.components.addressBar(journeyInfo: nil)

        addressBar.widthAnchor.constraint(equalToConstant: 400).isActive = true
        return addressBar
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

struct QuoteList: UIViewControllerRepresentable {

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}

    func makeUIViewController(context: Context) -> some UIViewController {
        return KarhooUI.components.quoteList()
    }
}
