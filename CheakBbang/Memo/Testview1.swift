//
//  Testview1.swift
//  CheakBbang
//
//  Created by 박다현 on 9/20/24.
//

import SwiftUI

struct Testview1: View {
    var body: some View {
        NavigationLink {
            TestView()
        } label: {
            Text("이동")
        }

    }
}

#Preview {
    Testview1()
}
