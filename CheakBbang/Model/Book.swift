//
//  Book.swift
//  CheakBbang
//
//  Created by 박다현 on 9/11/24.
//

import Foundation

struct Book: Decodable {
    let version: String
    let title: String
    let link: String
    let pubDate: String
    let totalResults, startIndex, itemsPerPage: Int
    let query: String
    let searchCategoryID: Int
    let searchCategoryName: String
    let item: [Item]

    enum CodingKeys: String, CodingKey {
        case version, title, link, pubDate, totalResults, startIndex, itemsPerPage, query
        case searchCategoryID = "searchCategoryId"
        case searchCategoryName, item
    }
}

// MARK: - Item
struct Item: Decodable {
    let title: String
    let link: String
    let author, pubDate, description, isbn: String
    let isbn13: String
    let itemID: Int
    let cover: String
    let categoryID: Int
    let categoryName, publisher: String
    let adult: Bool
    let customerReviewRank: Int
    let subInfo: SubInfo


    enum CodingKeys: String, CodingKey {
        case title
        case link
        case author
        case pubDate
        case description
        case isbn
        case isbn13
        case itemID = "itemId"
        case cover
        case categoryID = "categoryId"
        case categoryName
        case publisher
        case adult
        case customerReviewRank
        case subInfo
    }
}

// MARK: - SubInfo
struct SubInfo: Decodable {
    let subTitle, originalTitle: String?
    let itemPage: Int?
}
