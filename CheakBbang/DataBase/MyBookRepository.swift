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
    
    //Create
    func createData(data: MyBook) {
        do {
            try realm.write {
                realm.add(data)
            }
        } catch {
            print("faild to create data")
        }

    }

    
    func createMemo(book: MyBook, data: Memo) {
        do {
            let book = fetchSingleItem(book.id)
            try realm.write {
                book?.memo.append(data)
            }
        } catch {
            print("faild to create data")
        }

    }
    
    
    
    //Delete
    func deleteData(data: MyBook) {
        let data = realm.object(ofType: MyBook.self, forPrimaryKey: data.id)!

        do {
            try realm.write {
                realm.delete(data)
            }
        } catch {
            print("faild to delete data")
        }
    }
    
    //Delete All
    func deleteAllData() {
        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            print("faild to delete all")
        }
    }
    
    //Read one
    func fetchSingleItem(_ id: ObjectId) -> MyBook? {
        let specificItem = realm.object(ofType: MyBook.self, forPrimaryKey: id)
        return specificItem
    }
    
    func fetchSingleMemo(_ id: ObjectId) -> Memo? {
        let specificItem = realm.object(ofType: Memo.self, forPrimaryKey: id)
        return specificItem
    }
    
    //Read all
    func fetchAllItem(_ ascending: Bool) -> [MyBook]? {
        let value = realm.objects(MyBook.self).sorted(byKeyPath: "startDate", ascending: ascending)
        return Array(value)
    }
}
