//
//  Book.swift
//  CheakBbang
//
//  Created by 박다현 on 9/11/24.
//

import Foundation

struct BookDTO: Decodable {
    let version: String
    let title: String
    let link: String
    let pubDate: String
    let totalResults, startIndex, itemsPerPage: Int
    let query: String
    let searchCategoryID: Int
    let searchCategoryName: String
    let item: [ItemDTO]

    enum CodingKeys: String, CodingKey {
        case version, title, link, pubDate, totalResults, startIndex, itemsPerPage, query
        case searchCategoryID = "searchCategoryId"
        case searchCategoryName, item
    }
    
    func toModel() -> BookModel {
        .init(version: version, title: title, link: link, pubDate: pubDate, totalResults: totalResults, startIndex: startIndex, itemsPerPage: itemsPerPage, query: query, searchCategoryID: searchCategoryID, searchCategoryName: searchCategoryName, item: item.map{$0.toModel()})
    }
}

// MARK: - Item
struct ItemDTO: Decodable, Hashable {
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
    let subInfo: SubInfoDTO


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
    
    func toModel() -> ItemModel {
        .init(title: title, link: link, author: author, pubDate: pubDate, description: description, isbn: isbn, isbn13: isbn13, itemID: itemID, cover: cover, categoryID: categoryID, categoryName: categoryName, publisher: publisher, adult: adult, customerReviewRank: customerReviewRank, subInfo: subInfo.toModel())
    }
}

// MARK: - SubInfo
struct SubInfoDTO: Decodable, Hashable {
    let subTitle, originalTitle: String?
    let itemPage: Int?
    
    func toModel() -> SubInfoModel {
        .init(subTitle: subTitle, originalTitle: originalTitle, itemPage: itemPage)
    }
}
