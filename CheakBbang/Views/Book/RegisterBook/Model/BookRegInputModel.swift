//
//  BookRegInputModel.swift
//  CheakBbang
//
//  Created by 박다현 on 12/26/24.
//

import Foundation

struct BookRegInputModel {
    var title: String
    var author: String
    var isbn13: String
    var cover: String
    var publisher: String
    var page: String
    
    init(title: String, author: String, isbn13: String, cover: String, publisher: String, page: String) {
        self.title = title
        self.author = author
        self.isbn13 = isbn13
        self.cover = cover
        self.publisher = publisher
        self.page = page
    }
    
    init() {
        self.title = ""
        self.author = ""
        self.isbn13 = ""
        self.cover = ""
        self.publisher = ""
        self.page = ""
    }
}
