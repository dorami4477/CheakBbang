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
        AsyncImage(url: URL(string: url)){ image in
            switch image {
            case .empty:
                Image(systemName: "star")
                
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
                
            case .failure:
                Image(systemName: "star")
                
            @unknown default:
                Image(systemName: "star")
            }
        }
    }
}

#Preview {
    ImageWrapper(url: "https://image.aladin.co.kr/product/18/70/coversum/8973372122_1.gif")
}
