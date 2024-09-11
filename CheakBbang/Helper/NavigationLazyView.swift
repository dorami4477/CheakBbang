//
//  NavigationLazyView.swift
//  CheakBbang
//
//  Created by 박다현 on 9/11/24.
//

import SwiftUI

struct NavigationLazyView<Content: View>: View {
    
    let build: () -> Content
    
    var body: some View {
        build()
    }
    
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
}
