//
//  BookMapper.swift
//  CheakBbang
//
//  Created by 박다현 on 12/27/24.
//

import Foundation

struct BookMapper {
    static func toEntity(book: BookRegInputModel, review: ReviewRegInputModel) -> MyBook {
        let myBook = MyBook(itemId: Int(book.isbn13) ?? 0,
                            isCustomBook: true,
                            title: book.title,
                            originalTitle: "",
                            author: book.author,
                            publisher: book.publisher,
                            pubDate: book.pubDate,
                            explanation: book.explain,
                            cover: "",
                            isbn13: book.isbn13,
                            rate: review.rating,
                            page: Int(book.page) ?? 100,
                            status: review.readingState,
                            startDate: review.startDate,
                            endDate: review.endDate)
        myBook.cover = "\(myBook.id)"
        return myBook
    }
}
