//
//  SearchView.swift
//  CheakBbang
//
//  Created by 박다현 on 9/11/24.
//

import SwiftUI

struct SearchView: View {
    @State private var searchTerm = ""
    @StateObject var viewModel = SearchViewModel()
    
    var body: some View {
        ScrollView{
            LazyVStack {
                ForEach(viewModel.output.bookList.item, id: \.itemID) { item in
                    Text("\(item.title)")
                }
            }
        }
        .searchable(text: $searchTerm, prompt: "책 제목을 검색해보세요!")
        .onSubmit(of: .search) {
            viewModel.action(.searchOnSubmit(search: searchTerm))
        }
    }
}

#Preview {
    SearchView()
}
