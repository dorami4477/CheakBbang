//
//  BookListRow.swift
//  CheakBbang
//
//  Created by 박다현 on 9/16/24.
//

import SwiftUI

struct BookListRow: View {
    let item: Item

    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            BookCover(coverUrl: item.cover, size: CGSize(width: 118, height: 146))
            VStack(alignment: .leading, spacing: 5) {
                Text(item.title)
                    .font(.headline)
                    .fontWeight(.bold)
                
                Text(item.author + " / " + item.publisher + " / " + item.pubDate)
                .foregroundStyle(.gray)
                .font(.caption)
                .padding(.bottom, 4)
                
                HStack {
                    NavigationLink {
                        NavigationLazyView(SearchResultDetailView(viewModel: SearchResultDetailViewModel(), itemId: item.isbn13))
                    } label: {
                        Text("상세정보")
                            .asCaplusButton(color: .gray)
                    }
                    
                    NavigationLink {
                        NavigationLazyView(AddBookView(isbn13: item.isbn13, viewModel: AddBookViewModel()))
                    } label: {
                        Text("내 서재에 저장")
                            .asCaplusButton(color: .accentColor)
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
}
