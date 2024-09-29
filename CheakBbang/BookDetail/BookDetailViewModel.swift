//
//  BookDetailViewModel.swift
//  CheakBbang
//
//  Created by 박다현 on 9/16/24.
//

import Foundation
import Combine

final class BookDetailViewModel: ViewModelType {
    let repository = MyBookRepository()
    var cancellables = Set<AnyCancellable>()
    var input = Input()
    @Published var output = Output()

    init() {
        transform()
    }
}

// MARK: - Input / Output
extension BookDetailViewModel {
    struct Input {
        let viewOnAppear = PassthroughSubject<MyBook, Never>()
        let deleteButtonTap = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
         var book: MyBook = MyBook()
    }
    
    func transform() {
        input.viewOnAppear
            .sink { [weak self] book in
                if let bookData = self?.repository?.fetchSingleItem(book.id) {
                    self?.output.book = bookData
                }
            }
            .store(in: &cancellables)
        
        input.deleteButtonTap
            .combineLatest(input.viewOnAppear)
            .map { _, item in
                item
            }
            .eraseToAnyPublisher()
            .sink { [weak self] item in
                item.memo.forEach({ memo in
                    PhotoFileManager.shared.removeImageFromDocument(filename: "\(memo.id)")
                })
                self?.repository?.deleteSingleBook(item)
            }
            .store(in: &cancellables)
    }

}

// MARK: - Action
extension BookDetailViewModel {
    enum Action {
        case viewOnAppear(item: MyBook)
        case deleteButtonTap
    }
    
    func action(_ action: Action) {
        switch action {
        case .viewOnAppear(let item):
            input.viewOnAppear.send(item)
            
        case .deleteButtonTap:
            input.deleteButtonTap.send(())
        }
    }
}
