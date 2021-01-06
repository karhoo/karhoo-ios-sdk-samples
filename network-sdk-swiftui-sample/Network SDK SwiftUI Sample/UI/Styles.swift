//
//  Styles.swift
//  Network SDK SwiftUI Sample
//
//  Created by Jo Santamaria on 06/01/2021.
//  Copyright © 2021 Karhoo. All rights reserved.
//

import Foundation
import SwiftUI

struct TitleStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title)
            .foregroundColor(.primary)
    }
}

struct HeadlineStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .center)
    }
}

struct SubHeadlineStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
    }
}

struct ActionButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.white)
            .padding(10)
    }
}

struct ContentStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.body)
            .lineSpacing(4)
            .foregroundColor(.secondary)
    }
}

extension Text {
    func textStyle<Style: ViewModifier>(_ style: Style) -> some View {
        ModifiedContent(content: self, modifier: style)
    }
}
