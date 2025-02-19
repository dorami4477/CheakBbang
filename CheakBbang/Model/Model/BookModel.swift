//
//  BookModel.swift
//  CheakBbang
//
//  Created by 박다현 on 12/26/24.
//

import Foundation

struct BookModel {
    let version: String
    let title: String
    let link: String
    let pubDate: String
    let totalResults, startIndex, itemsPerPage: Int
    let query: String
    let searchCategoryID: Int
    let searchCategoryName: String
    let item: [ItemModel]

}

// MARK: - Item
struct ItemModel {
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
    let subInfo: SubInfoModel
}

// MARK: - SubInfo
struct SubInfoModel {
    let subTitle, originalTitle: String?
    let itemPage: Int?
}
