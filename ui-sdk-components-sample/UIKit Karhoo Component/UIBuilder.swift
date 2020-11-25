//
//  UIBuilders.swift
//  UIKit Karhoo Component
//
//

import UIKit

struct UIBuilder {

    static func textField(placeholder: String,
                          isSecureTextEntry: Bool = false) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        textField.layer.borderWidth = 1.0
        textField.autocapitalizationType = .none
        textField.isSecureTextEntry = isSecureTextEntry
        textField.layer.borderColor = UIColor.black.cgColor
        return textField
    }

    static func button(title: String, titleColor: UIColor = .black) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }

    static func alert(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return alert
    }
}
