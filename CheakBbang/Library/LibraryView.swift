//
//  LibraryView.swift
//  CheakBbang
//
//  Created by 박다현 on 9/14/24.
//

import SwiftUI

struct LibraryView: View {
    @StateObject var viewModel: LibraryViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(viewModel.output.bookList.sorted(by: { $0.startDate > $1.startDate }), id: \.id) { book in
                    bookListRow(book)
                }
            }
            .padding()
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
            
            VStack(alignment: .leading, spacing: 5) {
                Text(book.title)
                    .bold()
                    .font(.headline)
                
                HStack(spacing: 5) {
                    Image(systemName: "checkmark")
                        .resizable()
                        .tint(.white)
                        .bold()
                        .frame(width:10, height:10)
                    Text("Done")
                        .bold()
                        .font(.caption)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 2)
                .background(Color.orange)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                HStack(spacing: 0) {
                    ForEach(0..<5) { index in
                        Image(systemName: index < book.rank ? "heart.fill" : "heart")
                            .foregroundColor(index < book.rank ? .red : .gray)
                    }
                }
                
                HStack(spacing: 0) {
                    Text(dataString(book.startDate) + " ~ ")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(dataString(book.endDate))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func dataString(_ date: Date) -> String {
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "yyyy.MM.dd"
        let savedDateString = myFormatter.string(from: date)
        return savedDateString
    }
}



