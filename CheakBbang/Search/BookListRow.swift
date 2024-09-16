//
//  BookListRow.swift
//  CheakBbang
//
//  Created by 박다현 on 9/16/24.
//

import SwiftUI

struct BookListRow: View {
    let item: Item

    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            BookCover(coverUrl: item.cover)
            VStack(alignment: .leading, spacing: 5) {
                Text(item.title)
                    .bold()
                NavigationLink {
                    NavigationLazyView(AddBookView(isbn13: item.isbn13, viewModel: AddBookViewModel()))
                } label: {
                    Text("추가하기")
                }

            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func dataString(_ date: Date) -> String {
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "yyyy.MM.dd"
        let savedDateString = myFormatter.string(from: date)
        return savedDateString
    }
}
