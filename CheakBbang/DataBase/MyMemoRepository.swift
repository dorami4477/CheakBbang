//
//  MyMemoRepository.swift
//  CheakBbang
//
//  Created by 박다현 on 10/21/24.
//

import Foundation
import RealmSwift

protocol MemoRepositoryProtocol {
    func addMemo(_ memo: Memo)
    func deleteSingleMemo(_ meme: MemoDTO)
    func fetchMemos() -> [MemoDTO]
    func fetchSingleBook(_ id: ObjectId) -> MyBookDTO?
    func fetchSingleMemo(_ id: ObjectId) -> MemoDTO?
    func editMemo(id: ObjectId, newMemo: Memo)
}

final class MyMemoRepository: MemoRepositoryProtocol {
    
    private let realm: Realm
    
    init?() {
        do {
            self.realm = try Realm()
        } catch {
            print("faild to initialze Realm")
            return nil
        }
    }
    
    func addMemo(_ memo: Memo) {
        do {
            guard let data = realm.object(ofType: MyBook.self, forPrimaryKey: memo.bookId) else { return }
            try realm.write {
                data.memo.append(memo)
            }
        } catch {
            print("Error adding MyBook and its memos: \(error)")
        }
    }
    
    func fetchMemos() -> [MemoDTO] {
        let items = realm.objects(Memo.self)
        return items.map { $0.toMemoDTO() }
    }
    
    func fetchSingleBook(_ id: ObjectId) -> MyBookDTO? {
        let specificItem = realm.object(ofType: MyBook.self, forPrimaryKey: id)
        return specificItem?.toMyBookDTO()
    }
    
    func fetchSingleMemo(_ id: ObjectId) -> MemoDTO? {
        let specificItem = realm.object(ofType: Memo.self, forPrimaryKey: id)
        return specificItem?.toMemoDTO()
    }
 
    func editMemo(id: ObjectId, newMemo: Memo) {
        do {
            guard let data = realm.object(ofType: Memo.self, forPrimaryKey: id) else { return }
            try realm.write {
                data.page = newMemo.page
                data.contents = newMemo.contents
            }
        } catch {
            print("Error editting memo: \(error)")
        }
    }
    
    func deleteSingleMemo(_ memo: MemoDTO) {
        do {
            try realm.write {
                guard let memo = realm.object(ofType: Memo.self, forPrimaryKey: memo.id) else { return }
                realm.delete(memo)
            }
        } catch {
            print("Error deleting memo: \(error)")
        }
    }

}

