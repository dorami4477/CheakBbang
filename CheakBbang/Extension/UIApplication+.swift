//
//  UIApplication.swift
//  CheakBbang
//
//  Created by 박다현 on 9/24/24.
//

import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
