//
//  BookCover.swift
//  CheakBbang
//
//  Created by 박다현 on 9/16/24.
//

import SwiftUI

struct BookCover: View {
    var coverUrl: URL?
    var size: CGSize
    
    var body: some View {
        AsyncImageWrapper(url: coverUrl)
            .frame(width: size.width * 0.77, height: size.width * 1.15)
            .clipped()
            .overlay(alignment: .top) {
                Image(ImageName.SingleBookCover)
                    .resizable()
                    .frame(width: size.width, height: size.height)
            }
            .frame(width: size.width, height: size.height)
    }
}

