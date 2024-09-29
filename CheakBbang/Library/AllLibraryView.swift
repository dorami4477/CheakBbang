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
        ScrollView {
            VStack(spacing: 25) {
                sectionView(.done, color: .finished)
                sectionView(.currenltyReading, color: .ongoing)
                sectionView(.wantToRead, color: .upcoming)
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
                LazyHStack(spacing: 0) {
                    ForEach(viewModel.dataBytype(type), id: \.id) { book in
                        NavigationLink {
                            NavigationLazyView(BookDetailView(viewModel: BookDetailViewModel(), item: book))
                        } label: {
                            BookCover(coverUrl: book.cover, size: CGSize(width: 118, height: 146))
                                .padding(10)
                        }
                    }
                }
                .padding(.leading, 20)
            }
            if viewModel.dataBytype(type).count == 0 {
                emptySelf(type, color: color)
            }
        }
        
    }

    func emptySelf(_ type: LibraryTab, color: Color) -> some View {
            HStack {
                ImageWrapper(name: ImageName.emptySelf)
                    .frame(width: 118, height: 146)
                    .padding(.top, 10)
                    .padding(.leading, 30)
                Spacer()
            }
    }
    
}
