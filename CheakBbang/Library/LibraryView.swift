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
            ImageWrapper(url: book.cover)
                .frame(width: 90, height: 135)
                .clipped()
                .overlay(alignment: .top) {
                    Image(ImageName.SingleBookCover)
                        .resizable()
                        .frame(width: 118, height: 146)
                }
                .frame(width: 118, height: 146)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(book.title)
                    .bold()
                
                HStack(spacing: 5) {
                    Image(systemName: "checkmark")
                        .resizable()
                        .tint(.white)
                        .bold()
                        .frame(width:10, height:10)
                    Text("\(viewModel.getReadState(book.status))")
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



