//
//  AddBookView.swift
//  CheakBbang
//
//  Created by 박다현 on 9/11/24.
//

import SwiftUI
import RealmSwift

struct AddBookView: View {
    @ObservedResults(MyBook.self) var bookList
    
    var isbn13: String
    @StateObject var viewModel: AddBookViewModel
    @State private var rank: String = ""
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: viewModel.output.bookItem.cover))
            Text(viewModel.output.bookItem.title)
            TextField("별점을 적으시오", text: $rank)
            DatePicker("시작일", selection: $startDate)
            DatePicker("종료일", selection: $endDate)
            Text("추가")
                .wrapToButton {
                    let newItem = MyBook(id: viewModel.output.bookItem.itemID, title: viewModel.output.bookItem.title, originalTitle: viewModel.output.bookItem.subInfo.originalTitle ?? "", author: viewModel.output.bookItem.author, publisher: viewModel.output.bookItem.publisher, pubDate: viewModel.output.bookItem.pubDate, explanation: viewModel.output.bookItem.description, cover: viewModel.output.bookItem.cover, isbn13: viewModel.output.bookItem.isbn13, rank: Int(rank) ?? 0, status: .ing, startDate: startDate, endDate: endDate)
                    $bookList.append(newItem)
                }

        }
        .task {
            viewModel.action(.viewOnTask(isbn: isbn13))
        }
    }
}

#Preview {
    AddBookView(isbn13: "9788965966463", viewModel: AddBookViewModel())
}
