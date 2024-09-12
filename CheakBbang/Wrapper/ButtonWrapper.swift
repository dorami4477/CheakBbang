//
//  ButtonWrapper.swift
//  CheakBbang
//
//  Created by 박다현 on 9/12/24.
//

import SwiftUI

private struct ButtonWrapper: ViewModifier {
    
    let action: () -> Void
    
    func body(content: Content) -> some View {
        Button(action: action, label: {
            content
        })
    }
}

extension View {
    func wrapToButton(action: @escaping ()-> Void) -> some View {
        modifier(ButtonWrapper(action: action))
    }
}
