//
//  SearchResultDetailView.swift
//  CheakBbang
//
//  Created by 박다현 on 9/18/24.
//

import SwiftUI

struct SearchResultDetailView: View {
    @StateObject var viewModel: SearchResultDetailViewModel
    var item: Item
    @State private var addNew = false
    @State private var toast: Toast? = nil
    
    var body: some View {
        ScrollView {
            VStack {
                BookCoverInfoView(bookId: "\(item.itemID)", coverUrl: viewModel.output.book.cover, title: viewModel.output.book.title, ogTitle: viewModel.output.book.subInfo.originalTitle ?? "")
                
                Divider()
                    .padding(.vertical)
                
                BookDetailBottomView(viewModel.output.book)
                
                NavigationLink {
                    AddBookView(viewModel: AddBookViewModel(), item: item, addNew: $addNew)
                } label: {
                    Text("내 서재에 저장")
                        .asfullCapsuleButton(background: .accent)
                        .padding(.vertical)
                }

                Spacer()
            }
            .padding()
        }
        .toastView(toast: $toast)
        .navigationTitle("도서 상세 정보")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear{
            viewModel.action(.viewOnTask(item: item))
            if addNew {
                toast = Toast(style: .success, message: "책이 추가되었습니다. :)")
                addNew = false
            } else {
                toast = nil
            }
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


