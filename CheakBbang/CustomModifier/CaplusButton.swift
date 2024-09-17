//
//  CaplusButton.swift
//  CheakBbang
//
//  Created by 박다현 on 9/17/24.
//

import SwiftUI

private struct CaplusButton: ViewModifier {
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .font(.caption)
            .fontWeight(.semibold)
            .padding(.vertical, 7)
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
            .foregroundColor(.white)
            .background(color)
            .clipShape(.capsule)
    }
    
}

extension View {
    func asCaplusButton(color: Color) -> some View {
        modifier(CaplusButton(color: color))
    }
}
