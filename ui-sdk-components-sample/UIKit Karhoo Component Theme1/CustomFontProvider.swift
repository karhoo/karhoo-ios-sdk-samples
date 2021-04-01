//
//  CustomFontProvider.swift
//  UIKit Karhoo Component
//
//  Created by Corneliu on 31.03.2021.
//

import Foundation
import KarhooUISDK

struct CustomFontProvider {
    static func getKarhooUIFont() -> FontFamily {
        return FontFamily(boldFont: "Montserrat-Bold", regularFont: "Roboto-Regular", lightFont: "Roboto-LightItalic")
    }
}
