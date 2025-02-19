//
//  LevelEntity.swift
//  CheakBbang
//
//  Created by 박다현 on 2/19/25.
//

import Foundation

import RealmSwift

final class LevelEntity: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var level: Int
    @Persisted var name: String
    @Persisted var cover: String
    
    convenience init(id: String, level: Int, name: String, cover: String) {
        self.init()
        self.id = id
        self.level = level
        self.name = name
        self.cover = cover
    }
    
    func toModel() -> LevelModel {
        .init(id: id, level: level, name: name, cover: cover)
    }
}
