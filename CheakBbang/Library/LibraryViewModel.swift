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
    let repository: BookRepositoryProtocol?
    var cancellables = Set<AnyCancellable>()
    var input = Input()
    @Published var output = Output()
    
    init(repository: BookRepositoryProtocol?) {
        self.repository = repository
        transform()
    }
}

// MARK: - Input / Output
extension LibraryViewModel {
    struct Input {
        let viewOnAppear = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        var bookList: [MyBookDTO] = []
        var totalPage: String = ""
        var bookCount: Int = 0
        var readState: String = ""
    }
    
    func transform() {
        input.viewOnAppear
            .sink { [weak self] _ in
                guard let self, let repository = self.repository else { return }
                self.output.bookList = repository.fetchBooks()
                self.updateOutput()
            }
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
    
    func dataBytype(_ type: LibraryTab) -> [MyBookDTO] {
        var list: [MyBookDTO] = []
        switch type {
        case .all:
            list = output.bookList.reversed()
        case .currenltyReading:
            list = output.bookList.filter{ $0.status == .ongoing }.reversed()
        case .done:
            list = output.bookList.filter{ $0.status == .finished }.reversed()
        case .wantToRead:
            list = output.bookList.filter{ $0.status == .upcoming }.reversed()
        }
        return list
    }
    
}


/*
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
            .receive(on: DispatchQueue.main)
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
    
    func dataBytype(_ type: LibraryTab) -> [MyBook] {
        var list: [MyBook] = []
        switch type {
        case .all:
            list = output.bookList
        case .currenltyReading:
            list = output.bookList.filter{ $0.status == .ongoing }
        case .done:
            list = output.bookList.filter{ $0.status == .finished }
        case .wantToRead:
            list = output.bookList.filter{ $0.status == .upcoming }
        }
        return list
    }
    
}
*/

// MARK: - Action
extension LibraryViewModel {
    enum Action {
        case viewOnAppear
    }
    
    func action(_ action: Action) {
        switch action {
        case .viewOnAppear:
            input.viewOnAppear.send(())
        }
    }
}
