//
//  FontWrapper.swift
//  CheakBbang
//
//  Created by 박다현 on 9/26/24.
//

import SwiftUI

private struct FontWrapper: ViewModifier {
    let size: CGFloat
    let weight: Font.Weight
    
    func body(content: Content) -> some View {
        content
            .font(Font.system(size: size))
            .fontWeight(weight)
            
    }
    
}

extension View {
    func asFontWrapper(size: CGFloat, weight: Font.Weight) -> some View {
        modifier(FontWrapper(size: size, weight: weight))
    }
}
