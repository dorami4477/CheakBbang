//
//  MyBookRepository.swift
//  CheakBbang
//
//  Created by 박다현 on 9/12/24.
//

import Foundation
import RealmSwift

final class MyBookRepository {
    
    private let realm: Realm
    
    init?() {
        do {
            self.realm = try Realm()
        } catch {
            print("faild to initialze Realm")
            return nil
        }
    }
    
    func deleteSingleBook(_ book: MyBook) {
        do {
            try realm.write {
                let memosToDelete = book.memo
                realm.delete(memosToDelete)
                realm.delete(book)
            }
        } catch {
            print("Error deleting MyBook and its memos: \(error)")
        }
    }
    
    func fetchSingleItem(_ id: ObjectId) -> MyBook? {
        let specificItem = realm.object(ofType: MyBook.self, forPrimaryKey: id)
        return specificItem
    }
}
