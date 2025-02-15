//
//  LevelDTO.swift
//  CheakBbang
//
//  Created by 박다현 on 2/5/25.
//

struct LevelDTO: Decodable {
    let id: String
    let level: Int
    let name: String
    let cover: String
    
    func toModel() -> LevelModel {
        .init(id: id, level: level, name: name, cover: cover)
    }
}
