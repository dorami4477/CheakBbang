//
//  MyBookModel.swift
//  CheakBbang
//
//  Created by 박다현 on 10/2/24.
//

import Foundation
import RealmSwift

struct MyBookModel {
    let id: ObjectId
    let itemId: Int
    let title: String
    let originalTitle: String
    let author: String
    let publisher: String
    let pubDate: String
    let explanation: String
    let cover: String
    let isbn13: String
    let rate: Double
    let memo: [MemoModel]
    let page: Int
    let status: ReadingState
    let startDate: Date
    let endDate: Date
}

struct MemoModel {
    let id: ObjectId
    let bookId: ObjectId
    let page: String
    let contents: String
    let contents2: String?
    let date: Date
}

struct UserModel {
    let id: ObjectId
    let nickname: String
    let level: Int
    let numberOfBooks: Int
    let pagesOfBooks: Int
    let character01: Int
    let character02: Int
}
