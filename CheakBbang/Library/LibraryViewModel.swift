//
//  LibraryViewModel.swift
//  CheakBbang
//
//  Created by 박다현 on 9/14/24.
//

import Foundation
import Combine
import RealmSwift

final class LibraryViewModel: ViewModelType {
    @ObservedResults(MyBook.self) var realmBookList
    var cancellables = Set<AnyCancellable>()
    var input = Input()
    @Published var output = Output()
    
    init() {
        transform()
    }
}

// MARK: - Input / Output
extension LibraryViewModel {
    struct Input {

    }
    
    struct Output {
        var bookList: [MyBook] = []
        var totalPage: String = ""
        var bookCount: Int = 0
        var readState: String = ""
    }
    
    func transform() {
        realmBookList.collectionPublisher
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
    
}

// MARK: - Action
extension LibraryViewModel {
    enum Action {
    }
    
    func action(_ action: Action) {

    }
}
