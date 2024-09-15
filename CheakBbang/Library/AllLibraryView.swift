//
//  AllLibraryView.swift
//  CheakBbang
//
//  Created by 박다현 on 9/15/24.
//

import SwiftUI

struct AllLibraryView: View {
    @StateObject var viewModel: LibraryViewModel
    
    var body: some View {
        VStack {
            sectionView("읽은 책")
            sectionView("읽고 있는 책")
            sectionView("읽고 싶은 책")
        }
    }
    
    func sectionView(_ title: String) -> some View {
        VStack {
            Text(title)
            ScrollView(.horizontal) {
                LazyHStack(spacing: 20) {
                    ForEach(viewModel.output.bookList, id: \.id) { book in
                        bookListRow(book)
                    }
                }
                .padding()
            }
        }
    }
    
    func bookListRow(_ book: MyBook) -> some View {
        HStack(alignment: .top, spacing: 15) {
            Image("SingleBookCover")
                .resizable()
                .frame(width: 118, height: 146)
                .overlay(alignment: .top) {
                    ImageWrapper(url: book.cover)
                        .frame(width: 105, height: 136)
                }
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    AllLibraryView(viewModel: LibraryViewModel())
}
