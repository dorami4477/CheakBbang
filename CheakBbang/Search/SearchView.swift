//
//  SearchView.swift
//  CheakBbang
//
//  Created by 박다현 on 9/11/24.
//

import SwiftUI

struct SearchView: View {
    @State private var searchTerm = ""
    @StateObject var viewModel: SearchViewModel
    
    var body: some View {
        ScrollView{
            LazyVStack {
                ForEach(viewModel.output.bookList.item, id: \.itemID) { item in
                    BookListRow(item: item)
                }
            }
        }
        .searchable(text: $searchTerm, prompt: "책 제목을 검색해보세요!")
        .onSubmit(of: .search) {
            viewModel.action(.searchOnSubmit(search: searchTerm))
        }
    }
}

struct BookListRow: View {
    let item: Item
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string:item.cover)!)
            Text("\(item.title)")
            NavigationLink {
                NavigationLazyView(AddBookView(isbn13: item.isbn13, viewModel: AddBookViewModel()))
            } label: {
                Text("추가하기")
            }

        }
    }
}

#Preview {
    SearchView(viewModel: SearchViewModel())
}
