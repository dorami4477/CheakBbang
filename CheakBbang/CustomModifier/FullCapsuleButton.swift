//
//  FullCapsuleButton.swift
//  CheakBbang
//
//  Created by 박다현 on 9/22/24.
//

import SwiftUI

private struct FullCapsuleButton: ViewModifier {
    var background:Color
    
    func body(content: Content) -> some View {
            content
                .font(.system(size: 18, weight: .bold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .padding(.horizontal)
                .background(background)
                .foregroundColor(.white)
                .clipShape(.capsule)
    }
}

extension View {
    func asfullCapsuleButton(background: Color) -> some View {
        modifier(FullCapsuleButton(background: background))
    }
}
