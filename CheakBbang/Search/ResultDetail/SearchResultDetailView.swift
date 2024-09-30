//
//  SearchResultDetailView.swift
//  CheakBbang
//
//  Created by 박다현 on 9/18/24.
//

import SwiftUI

struct SearchResultDetailView: View {
    @StateObject var viewModel: SearchResultDetailViewModel
    //var itemId: String
    var item: Item
    
    var body: some View {
        ScrollView {
            VStack {
                BookCoverInfoView(coverUrl: viewModel.output.book.cover, title: viewModel.output.book.title, ogTitle: viewModel.output.book.subInfo.originalTitle ?? "")
                
                Divider()
                    .padding(.vertical)
                
                BookDetailBottomView(viewModel.output.book)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("도서 상세 정보")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear{
            viewModel.action(.viewOnTask(item: item))
        }
    }
    
    func BookDetailBottomView(_ item: Item) -> some View {
            VStack(alignment: .leading, spacing: 8) {
                BiblioRowView(title: "작가", content: item.author)
                BiblioRowView(title: "출판사", content: item.publisher)
                BiblioRowView(title: "출판일", content: item.pubDate)
                BiblioRowView(title: "페이지수", content: "\(item.subInfo.itemPage ?? 0)")
                BiblioRowView(title: "설명글", content: item.description)
            }
            .font(.body)
    }
}


