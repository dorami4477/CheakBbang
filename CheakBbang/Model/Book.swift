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
    let itemID, priceSales, priceStandard: Int
    let mallType, stockStatus: String
    let mileage: Int
    let cover: String
    let categoryID: Int
    let categoryName, publisher: String
    let salesPoint: Int
    let adult, fixedPrice: Bool
    let customerReviewRank: Int
    let subInfo: SubInfo

    enum CodingKeys: String, CodingKey {
        case title, link, author, pubDate, description, isbn, isbn13
        case itemID = "itemId"
        case priceSales, priceStandard, mallType, stockStatus, mileage, cover
        case categoryID = "categoryId"
        case categoryName, publisher, salesPoint, adult, fixedPrice, customerReviewRank, subInfo
    }
}

// MARK: - SubInfo
struct SubInfo: Decodable {
    let subTitle, originalTitle: String?
    let itemPage: Int?
}
