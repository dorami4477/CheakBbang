//
//  MyBook.swift
//  CheakBbang
//
//  Created by 박다현 on 9/12/24.
//

import Foundation

import RealmSwift

final class MyBook: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var itemId: Int
    @Persisted var isCustomBook: Bool
    @Persisted(indexed: true) var title: String
    @Persisted var originalTitle: String
    @Persisted var author: String
    @Persisted var publisher: String
    @Persisted var pubDate: String
    @Persisted var explanation: String
    @Persisted var cover: String
    @Persisted var isbn13: String
    @Persisted var rate: Double
    @Persisted var memo: List<Memo> = List<Memo>()
    @Persisted var page: Int
    @Persisted var status: ReadingState
    @Persisted var startDate: Date
    @Persisted var endDate: Date
    
    convenience init(itemId: Int, isCustomBook: Bool = false, title: String, originalTitle: String, author: String, publisher: String, pubDate: String, explanation: String, cover: String, isbn13: String, rate: Double, memo: List<Memo> = List<Memo>(), page: Int = 0, status: ReadingState, startDate: Date, endDate: Date) {
        self.init()
        self.itemId = itemId
        self.isCustomBook = isCustomBook
        self.title = title
        self.originalTitle = originalTitle
        self.author = author
        self.publisher = publisher
        self.pubDate = pubDate
        self.explanation = explanation
        self.cover = cover
        self.isbn13 = isbn13
        self.rate = rate
        self.memo = memo
        self.page = page
        self.status = status
        self.startDate = startDate
        self.endDate = endDate
    }
    
    func toMyBookModel() -> MyBookModel {
        .init(id: id, itemId: itemId, title: title, isCustomBook: isCustomBook, originalTitle: originalTitle, author: author, publisher: publisher, pubDate: pubDate, explanation: explanation, cover: cover, isbn13: isbn13, rate: rate, memo: Array(_immutableCocoaArray: memo), page: page, status: status, startDate: startDate, endDate: endDate)
    }
}

final class Memo: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var bookId: ObjectId
    @Persisted var page: String
    @Persisted var contents: String
    @Persisted var contents2: String?
    @Persisted var date: Date
    
    let myBook = LinkingObjects(fromType: MyBook.self, property: "memo")
    
    convenience init(bookId: ObjectId, page: String, contents: String, content2: String? = nil, date: Date) {
        self.init()
        self.bookId = bookId
        self.page = page
        self.contents = contents
        self.contents2 = content2
        self.date = date
    }
    
    func toMemoModel() -> MemoModel {
        .init(id: id, bookId: bookId, page: page, contents: contents, contents2: contents2, date: date)
    }
}

final class User: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var nickname: String
    @Persisted var level: Int
    @Persisted var numberOfBooks: Int
    @Persisted var pagesOfBooks: Int
    @Persisted var character01: Int
    @Persisted var character02: Int
    
    convenience init(nickname: String, level: Int, numberOfBooks: Int, pagesOfBooks: Int, character01: Int, character02: Int) {
        self.init()
        self.nickname = nickname
        self.level = level
        self.numberOfBooks = numberOfBooks
        self.pagesOfBooks = pagesOfBooks
        self.character01 = character01
        self.character02 = character02
    }
    
    func toUserModel() -> UserModel {
        .init(id: id, nickname: nickname, level: level, numberOfBooks: numberOfBooks, pagesOfBooks: pagesOfBooks, character01: character01, character02: character02)
    }
}
