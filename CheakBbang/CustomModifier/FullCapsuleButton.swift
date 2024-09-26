//
//  FullCapsuleButton.swift
//  CheakBbang
//
//  Created by 박다현 on 9/22/24.
//

import SwiftUI

private struct FullCapsuleButton: ViewModifier {
    
    func body(content: Content) -> some View {
            content
                .font(.system(size: 18, weight: .bold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .padding(.horizontal)
                .background(.accent)
                .foregroundColor(.white)
                .clipShape(.capsule)
    }
}

extension View {
    func asfullCapsuleButton() -> some View {
        modifier(FullCapsuleButton())
    }
}
