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
            sectionWrap(.done, color: .orange)
            sectionWrap(.currenltyReading, color: .purple)
            sectionWrap(.wantToRead, color: .green)
        }
    }
    
    @ViewBuilder
    func sectionWrap(_ type: LibraryTab, color: Color) -> some View {
        if dateBytype(type).count != 0 {
            sectionView(type, color: color)
        } else {
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
                .padding(.bottom, 12)
                HStack {
                    ImageWrapper(name: ImageName.emptySelf)
                        .frame(width: 118, height: 146)
                        .padding(.leading, 30)
                    Spacer()
                }
            }
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

                        NavigationLink {
                            NavigationLazyView(BookDetailView(viewModel: BookDetailViewModel(), item: book))
                        } label: {
                            BookCover(coverUrl: book.cover, size: CGSize(width: 118, height: 146))
                        }
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
            list = viewModel.output.bookList.filter{ $0.status == .ongoing }
        case .currenltyReading:
            list = viewModel.output.bookList.filter{ $0.status == .ongoing }
        case .done:
            list = viewModel.output.bookList.filter{ $0.status == .finished }
        case .wantToRead:
            list = viewModel.output.bookList.filter{ $0.status == .upcoming }
        }
        return list
    }
    
}

#Preview {
    AllLibraryView(viewModel: LibraryViewModel())
}
