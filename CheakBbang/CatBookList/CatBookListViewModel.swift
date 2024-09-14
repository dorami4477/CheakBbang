//
//  CatBookListViewModel.swift
//  CheakBbang
//
//  Created by 박다현 on 9/13/24.
//

import Foundation
import Combine
import RealmSwift

final class CatBookListViewModel: ViewModelType {
    //@ObservedResults(MyBook.self) var realmBookList
    private var realm: Realm
    //@Published var bookList: [MyBook] = []
    
    var cancellables = Set<AnyCancellable>()
    var input = Input()
    @Published var output = Output()
    
    init() {
        self.realm = try! Realm()
        transform()
    }
}

// MARK: - Input / Output
extension CatBookListViewModel {
    struct Input {

    }
    
    struct Output {
        var bookList: [MyBook] = []
        var totalPage: String = ""
        var bookCount: Int = 0
    }
    
    func transform() {
        let books = realm.objects(MyBook.self)
        books.collectionPublisher
            .map { Array($0) }
            .sink(receiveCompletion: { completion in
                print(completion)
            }, receiveValue: { [weak self] books in
                guard let self = self else { return }
                self.output.bookList = books
                self.updateOutput()
            })
            .store(in: &cancellables)
    }
    
    private func updateOutput() {
        let totalPage = output.bookList.reduce(0) { $0 + $1.page }
        self.output.totalPage = totalPage.formatted()
        self.output.bookCount = output.bookList.count
    }
    
    func dataString(date: Date) -> String {
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "yyyyMMddHHmmss"
        let savedDateString = myFormatter.string(from: date)
        return savedDateString
    }
    
    func isLeadingAlignment(for index: Int) -> Bool {
        let share = index / 5
        return share % 2 == 0
    }
    
    func bookImageHeight(_ page: Int) -> CGFloat {
        switch page {
        case 0..<100:
            return 28
        case 100..<200:
            return 34
        case 200..<300:
            return 38
        case 300..<400:
            return 44
        case 400...:
            return 51
        default:
            return 30
        }
    }
    
    func bookImage(_ page: Int) -> String {
        let randomColor = Int.random(in: 1...4)
        
        switch page {
        case 0..<100:
            return "book_\(randomColor)_01"
        case 100..<200:
            return "book_\(randomColor)_02"
        case 200..<300:
            return "book_\(randomColor)_03"
        case 300..<400:
            return "book_\(randomColor)_04"
        case 400...:
            return "book_\(randomColor)_05"
        default:
            return "book_\(randomColor)_01"
        }
    }
}

// MARK: - Action
extension CatBookListViewModel {
    enum Action {
    }
    
    func action(_ action: Action) {

    }
}
