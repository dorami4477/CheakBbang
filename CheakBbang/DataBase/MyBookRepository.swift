//
//  MyBookRepository.swift
//  CheakBbang
//
//  Created by 박다현 on 9/12/24.
//

import Foundation
import RealmSwift

protocol BookRepositoryProtocol {
    func addMemo(_ memo: Memo)
    func addBook(id:String?, book: MyBook) -> MyBook?
    
    func deleteSingleBook(_ book: MyBookModel)
    func deleteSingleMemo(_ meme: MemoModel)
    
    func fetchBooks() -> [MyBookModel]
    func fetchMemos() -> [MemoModel]
    
    func fetchSingleBookModel(_ id: ObjectId) -> MyBookModel?
    func fetchSingleItem(_ id: ObjectId) -> MyBook?
    func fetchSingleMemo(_ id: ObjectId) -> MemoModel?
    
    func editMemo(id: ObjectId, newMemo: Memo)
    func editBookReview(_ id: ObjectId, rate: Double, status: ReadingState, startDate: Date, endDate: Date)
}

final class MyBookRepository: BookRepositoryProtocol {
    private let realm: Realm
    
    init?() {
        MyBookRepository.migrationVer01()
        
        do {
            self.realm = try Realm()
            print(realm.configuration.fileURL!)
        } catch {
            print("faild to initialze Realm")
            return nil
        }
    }
    
    func deleteSingleBook(_ book: MyBookModel) {
        do {
            try realm.write {
                guard let book = realm.object(ofType: MyBook.self, forPrimaryKey: book.id) else { return }
                let memosToDelete = book.memo
                realm.delete(memosToDelete)
                realm.delete(book)
            }
        } catch {
            print("Error deleting MyBook and its memos: \(error)")
        }
    }
    
    func fetchBooks() -> [MyBookModel] {
        let items = realm.objects(MyBook.self)
        return items.map { $0.toMyBookModel() }
    }
    
    func fetchMemos() -> [MemoModel] {
        let items = realm.objects(Memo.self)
        return items.map { $0.toMemoModel() }
    }
    
    func fetchSingleBookModel(_ id: ObjectId) -> MyBookModel? {
        let specificItem = realm.object(ofType: MyBook.self, forPrimaryKey: id)
        return specificItem?.toMyBookModel()
    }
    
    func fetchSingleMemo(_ id: ObjectId) -> MemoModel? {
        let specificItem = realm.object(ofType: Memo.self, forPrimaryKey: id)
        return specificItem?.toMemoModel()
    }
    
    func fetchSingleItem(_ id: ObjectId) -> MyBook? {
        let specificItem = realm.object(ofType: MyBook.self, forPrimaryKey: id)
        return specificItem
    }
    
    func deleteSingleMemo(_ memo: MemoModel) {
        do {
            try realm.write {
                guard let memo = realm.object(ofType: Memo.self, forPrimaryKey: memo.id) else { return }
                realm.delete(memo)
            }
        } catch {
            print("Error deleting MyBook and its memos: \(error)")
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
    
    
    func editMemo(id: ObjectId, newMemo: Memo) {
        do {
            guard let data = realm.object(ofType: Memo.self, forPrimaryKey: id) else { return }
            try realm.write {
                data.page = newMemo.page
                data.contents = newMemo.contents
            }
        } catch {
            print("Error deleting MyBook and its memos: \(error)")
        }
    }
    
    func editBookReview(_ id: ObjectId, rate: Double, status: ReadingState, startDate: Date, endDate: Date) {
        guard let data = realm.object(ofType: MyBook.self, forPrimaryKey: id) else { return }
        try! self.realm.write {
            data.rate = rate
            data.status = status
            data.startDate = startDate
            data.endDate = endDate
        }
    }

    func addBook(id: String?, book: MyBook) -> MyBook? {
        try? realm.write {
            if let id, let objectId = try? ObjectId(string: id),
               let existingBook = realm.object(ofType: MyBook.self, forPrimaryKey: objectId) {
                existingBook.title = book.title
                existingBook.author = book.author
                existingBook.publisher = book.publisher
                existingBook.pubDate = book.pubDate
                existingBook.explanation = book.explanation
                existingBook.isbn13 = book.isbn13
                existingBook.page = book.page
                
                print("Updated existing book:", existingBook)
                return existingBook
            } else {
                realm.add(book)
                print("Added new book:", book)
                return book
            }
        }
    }
}

// MARK: - Migration
extension MyBookRepository {
    static func migrationVer01() {
        let config = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 1 {
                    migration.enumerateObjects(ofType: MyBook.className()) { oldObject, newObject in
                        newObject!["isCustomBook"] = false
                    }
                }
            }
        )

        Realm.Configuration.defaultConfiguration = config
    }
}
