//
//  LibraryView.swift
//  CheakBbang
//
//  Created by 박다현 on 9/14/24.
//

import SwiftUI
import RealmSwift

struct LibraryView: View {
    @StateObject var viewModel: LibraryViewModel
    var status: ReadingState
    
    var body: some View {
        if viewModel.output.bookList.filter({ $0.status == status }).count != 0 {
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(viewModel.output.bookList.filter{ $0.status == status }, id: \.id) { book in
                        NavigationLink {
                            NavigationLazyView(BookDetailView(viewModel: BookDetailViewModel(), item: book))
                        } label: {
                            bookListRow(book: book)
                        }
                    }
                }
                .padding()
            }
        } else {
            Text("\(status.rawValue)을 등록해주세요:)")
        }
    }
}
    struct bookListRow: View {
        var book: MyBook
        
        var body: some View {
            HStack(alignment: .top, spacing: 15) {
                BookCover(coverUrl: book.cover, size: CGSize(width: 118, height: 146))
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(book.title)
                        .bold()
                        .foregroundStyle(.black)
                        .multilineTextAlignment(.leading)
                    
                    Image(book.status.imageName)
                        .resizable()
                        .frame(width:84.5, height:17.5)
                    
                    RratingHeartUneditableView(rating: book.rate, isEditable: false, size: 20)
                    
                    if book.status != .upcoming {
                        HStack(spacing: 0) {
                            Text("\(book.startDate.dateString()) -")
                                .font(.caption)
                                .foregroundColor(.gray)
                            if book.status == .finished {
                                Text(" \(book.endDate.dateString())")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    




