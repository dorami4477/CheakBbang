//
//  SearchResultDetailView.swift
//  CheakBbang
//
//  Created by 박다현 on 9/18/24.
//

import SwiftUI

struct SearchResultDetailView: View {
    var item: Item
    
    var body: some View {
        ScrollView {
            VStack {
                BookDetailTopView(coverUrl: item.cover, title: item.title, ogTitle: item.subInfo.originalTitle ?? "")
                
                Divider()
                    .padding(.vertical)
                
                BookDetailBottomView(item)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("도서 상세 정보")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func BookDetailBottomView(_ item: Item) -> some View {
            VStack(alignment: .leading, spacing: 8) {
                BottomRowView(title: "작가", content: item.author)
                BottomRowView(title: "출판사", content: item.publisher)
                BottomRowView(title: "출판일", content: item.pubDate)
                BottomRowView(title: "페이지수", content: "\(item.subInfo.itemPage ?? 0)")
                BottomRowView(title: "설명글", content: item.description)
            }
            .font(.body)
    }
}


