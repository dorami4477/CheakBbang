//
//  MyBookModel.swift
//  CheakBbang
//
//  Created by 박다현 on 10/2/24.
//

import Foundation
import RealmSwift

// DTO = Data Transfer Model
struct MyBookDTO {
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
    let memo: [MemoDTO]
    let page: Int
    let status: ReadingState
    let startDate: Date
    let endDate: Date
}

struct MemoDTO {
    let id: ObjectId
    let bookId: ObjectId
    let page: String
    let contents: String
    let contents2: String?
    let date: Date
}

struct UserDTO {
    let id: ObjectId
    let nickname: String
    let level: Int
    let numberOfBooks: Int
    let pagesOfBooks: Int
    let character01: Int
    let character02: Int
}
