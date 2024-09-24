//
//  ImageWrapper.swift
//  CheakBbang
//
//  Created by 박다현 on 9/12/24.
//

import SwiftUI

struct ImageWrapper: View {
    let url:URL?
    
    var body: some View {
        AsyncImage(url: url) { image in
            switch image {
            case .empty:
                Image(systemName: "star")
                
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                
            case .failure:
                Image(systemName: "star")
                
            @unknown default:
                Image(systemName: "star")
            }
        }
    }
}
