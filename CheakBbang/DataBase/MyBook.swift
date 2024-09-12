//
//  MyBook.swift
//  CheakBbang
//
//  Created by 박다현 on 9/12/24.
//

import Foundation
import RealmSwift

final class MyBook: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: Int
    @Persisted(indexed: true) var title: String
    @Persisted var originalTitle: String
    @Persisted var author: String
    @Persisted var publisher: String
    @Persisted var pubDate: String
    @Persisted var explanation: String
    @Persisted var cover: String
    @Persisted var isbn13: String
    @Persisted var rank: Int
    @Persisted var memo: List<Memo> = List<Memo>()
    @Persisted var page: Int?
    @Persisted var status: Status
    @Persisted var startDate: Date
    @Persisted var endDate: Date
    
    convenience init(id: Int, title: String, originalTitle: String, author: String, publisher: String, pubDate: String, explanation: String, cover: String, isbn13: String, rank: Int, memo: List<Memo> = List<Memo>(), page: Int? = nil, status: Status, startDate: Date, endDate: Date) {
        self.init()
        self.id = id
        self.title = title
        self.originalTitle = originalTitle
        self.author = author
        self.publisher = publisher
        self.pubDate = pubDate
        self.explanation = explanation
        self.cover = cover
        self.isbn13 = isbn13
        self.rank = rank
        self.memo = memo
        self.page = page
        self.status = status
        self.startDate = startDate
        self.endDate = endDate
    }
}

enum Status: String, PersistableEnum {
    case will
    case ing
    case done
}

final class Memo: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var page: Int
    @Persisted var title: String
    @Persisted var contents: String?
    @Persisted var date: Date
    
    convenience init(page: Int, title: String, contents: String? = nil, date: Date) {
        self.init()
        self.page = page
        self.title = title
        self.contents = contents
        self.date = date
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
}
