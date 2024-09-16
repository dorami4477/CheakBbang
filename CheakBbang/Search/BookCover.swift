//
//  BookCover.swift
//  CheakBbang
//
//  Created by 박다현 on 9/16/24.
//

import SwiftUI

struct BookCover: View {
    var coverUrl: String
    
    var body: some View {
        ImageWrapper(url: coverUrl)
            .frame(width: 90, height: 135)
            .clipped()
            .overlay(alignment: .top) {
                Image(ImageName.SingleBookCover)
                    .resizable()
                    .frame(width: 118, height: 146)
            }
            .frame(width: 118, height: 146)
    }
}

