//
//  Memo.swift
//  CheakBbang
//
//  Created by 박다현 on 2/19/25.
//

import Foundation

import RealmSwift

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
