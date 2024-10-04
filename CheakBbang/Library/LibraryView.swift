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
    @State private var filter = true //등록순
    
    var body: some View {
        VStack {
            if viewModel.output.bookList.filter({ $0.status == status }).count == 0 {
                Text("\(status.rawValue)을 등록해주세요:)")
                    .padding()
            } else {
                HStack {
                    Spacer()
                    HStack(spacing: 2) {
                        ImageWrapper(name: ImageName.filter01)
                            .foregroundStyle(filter ? .accent : .gray)
                            .frame(width: 18)
                        
                        Text("등록순")
                            .font(.system(size: 15))
                            .foregroundStyle(filter ? .accent : .gray)
                    }
                    .wrapToButton {
                        filter.toggle()
                    }
                    .padding(.trailing, 5)
                    HStack(spacing: 2) {
                        ImageWrapper(name: ImageName.filter02)
                            .foregroundStyle(filter ? .gray : .accent)
                            .frame(width: 18)
                        
                        Text("제목순")
                            .font(.system(size: 15))
                            .foregroundStyle(filter ? .gray : .accent)
                    }
                    .wrapToButton {
                        filter.toggle()
                    }
                }
                .padding(.horizontal)
                
                ScrollView {
                    LazyVStack(spacing: 20) {
                        ForEach(filteredList(filter), id: \.id) { book in
                            NavigationLink {
                                NavigationLazyView(BookDetailView(viewModel: BookDetailViewModel(), item: book))
                            } label: {
                                bookListRow(book: book)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            viewModel.action(.viewOnAppear)
        }
    }
    
    func filteredList(_ order: Bool) -> [MyBookDTO] {
        if order {
            return viewModel.output.bookList.filter{ $0.status == status }.reversed()
        } else {
            return viewModel.output.bookList.filter{ $0.status == status }.sorted { $0.title < $1.title }
        }
    }
}

struct bookListRow: View {
    var book: MyBookDTO
    
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




