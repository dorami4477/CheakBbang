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
    func deleteSingleMemo(_ meme: MemoModel)
    func fetchMemos() -> [MemoModel]
    func fetchSingleBook(_ id: ObjectId) -> MyBookModel?
    func fetchSingleMemo(_ id: ObjectId) -> MemoModel?
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
    
    func fetchMemos() -> [MemoModel] {
        let items = realm.objects(Memo.self)
        return items.map { $0.toMemoModel() }
    }
    
    func fetchSingleBook(_ id: ObjectId) -> MyBookModel? {
        let specificItem = realm.object(ofType: MyBook.self, forPrimaryKey: id)
        return specificItem?.toMyBookModel()
    }
    
    func fetchSingleMemo(_ id: ObjectId) -> MemoModel? {
        let specificItem = realm.object(ofType: Memo.self, forPrimaryKey: id)
        return specificItem?.toMemoModel()
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
    
    func deleteSingleMemo(_ memo: MemoModel) {
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

