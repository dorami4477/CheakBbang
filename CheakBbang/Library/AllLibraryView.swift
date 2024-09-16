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
        VStack(spacing: 30) {
            sectionView(.done, color: .orange)
            sectionView(.currenltyReading, color: .purple)
            sectionView(.wantToRead, color: .green)
        }
    }
    
    func sectionView(_ type: LibraryTab, color: Color) -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 5) {
                Circle()
                    .fill(color)
                    .frame(width: 10, height: 10)
                
                Text(type.rawValue)
                    .font(.subheadline)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal)
            ScrollView(.horizontal) {
                LazyHStack(spacing: 45) {
                    ForEach(dateBytype(type), id: \.id) { book in
                        BookCover(coverUrl: book.cover)
                    }
                }
                .padding(.leading, 30)
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
    
}

#Preview {
    AllLibraryView(viewModel: LibraryViewModel())
}
