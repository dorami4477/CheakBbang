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
                Image(ImageName.emptyBook)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
                
            } else {
                ProgressView()
            }
        }
    }
}


struct ImageWrapper: View {
    let name: String
    var contentMode:ContentMode = .fit
    
    var body: some View {
        Image(name)
            .resizable()
            .aspectRatio(contentMode: contentMode)
            .frame(maxWidth: .infinity)
    }
}
