//
//  LevelRepository.swift
//  CheakBbang
//
//  Created by 박다현 on 2/19/25.
//

import Foundation

import RealmSwift

final class LevelRepository {
    private let realm: Realm
    
    init?() {
        do {
            self.realm = try Realm()
            
        } catch {
            print("faild to initialze Realm")
            return nil
        }
    }
    
    func addLevelList(_ list: [LevelEntity]) {
        do {
            try realm.write {
                realm.add(list, update: .modified)
            }
        } catch {
            print("Error adding MyBook and its memos: \(error)")
        }
    }
    
    func fetchLevelList() -> [LevelModel] {
        let list = realm.objects(LevelEntity.self)
        
        return list.map{ $0.toModel() }
    }
}
