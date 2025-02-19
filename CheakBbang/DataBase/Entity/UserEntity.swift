//
//  UserEntity.swift
//  CheakBbang
//
//  Created by 박다현 on 2/19/25.
//

import Foundation

import RealmSwift

final class UserEntity: Object, ObjectKeyIdentifiable {
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
