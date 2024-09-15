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
            sectionView(.done, color: .orange)
            sectionView(.currenltyReading, color: .purple)
            sectionView(.wantToRead, color: .green)
        }
    }
    
    func sectionView(_ type: LibraryTab, color: Color) -> some View {
        VStack {
            HStack(spacing: 5) {
                Circle()
                    .fill(color)
                    .frame(width: 10, height: 10)
                
                Text(type.rawValue)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal) {
                LazyHStack(spacing: 20) {
                    ForEach(dateBytype(type), id: \.id) { book in
                        bookListRow(book)
                    }
                }
                .padding()
            }
        }
    }
    
    func dateBytype(_ type: LibraryTab) -> [MyBook] {
        var list: [MyBook] = []
        switch type {
        case .all:
            list = viewModel.output.bookList.filter{ $0.status == .ing }
        case .currenltyReading:
            list = viewModel.output.bookList.filter{ $0.status == .ing }
        case .done:
            list = viewModel.output.bookList.filter{ $0.status == .done }
        case .wantToRead:
            list = viewModel.output.bookList.filter{ $0.status == .will }
        }
        return list
    }
    
    func bookListRow(_ book: MyBook) -> some View {
        HStack(alignment: .top, spacing: 15) {
            ImageWrapper(url: book.cover)
                .frame(width: 90, height: 135)
                .clipped()
                .overlay(alignment: .top) {
                    Image(ImageName.SingleBookCover)
                        .resizable()
                        .frame(width: 118, height: 146)
                }
        }
        .frame(width: 118, height: 146)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    AllLibraryView(viewModel: LibraryViewModel())
}
