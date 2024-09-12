//
//  ImageWrapper.swift
//  CheakBbang
//
//  Created by 박다현 on 9/12/24.
//

import SwiftUI

struct ImageWrapper: View {
    let url:String
    var body: some View {
        AsyncImage(url: URL(string: url))
    }
}

#Preview {
    ImageWrapper(url: "https://image.aladin.co.kr/product/18/70/coversum/8973372122_1.gif")
}
