//
//  UIApplication+Extensions.swift
//  Calculator
//
//  Created by abhay mundhara on 14/06/2024.
//

import UIKit

extension UIApplication {
    static func dismissKeyboard() {
        UIApplication
            .shared
            .sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
