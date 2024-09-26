//
//  ImageWrapper.swift
//  CheakBbang
//
//  Created by 박다현 on 9/12/24.
//

import SwiftUI

struct AsyncImageWrapper: View {
    let url:URL?
    var contentMode:ContentMode = .fill
    
    var body: some View {
        AsyncImage(url: url) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
                
            } else if phase.error != nil {
                Image(systemName: "heart")
            } else {
                ProgressView()
            }
        }
    }
}
//Image(ImageName.memoViewTop)
//    .resizable()
//    .scaledToFit()
//    .frame(maxWidth: .infinity)

