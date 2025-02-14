//
//  BookDetailViewModel.swift
//  CheakBbang
//
//  Created by 박다현 on 9/16/24.
//

import Combine
import Foundation

final class BookDetailViewModel: ViewModelType {
    let repository: BookRepositoryProtocol?
    var cancellables = Set<AnyCancellable>()
    var input = Input()
    @Published var output = Output()

    init(repository: BookRepositoryProtocol?) {
        self.repository = repository
        transform()
    }
    
    deinit {
        print("BookDetailViewModel Deinit")
    }
}

// MARK: - Input / Output
extension BookDetailViewModel {
    struct Input {
        let viewOnAppear = PassthroughSubject<(MyBookModel, Bool), Never>()
        let modified = PassthroughSubject<MyBookModel, Never>()
        let deleteButtonTap = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        var book: MyBookModel = MyBook().toMyBookModel()
    }
    
    func transform() {
        input.viewOnAppear
            .sink { [weak self] (book, isModified) in
                if let bookData = self?.repository?.fetchSingleBookModel(book.id) {
                    self?.output.book = bookData
                }
            }
            .store(in: &cancellables)
        
        
        input.deleteButtonTap
            .combineLatest(input.viewOnAppear)
            .map { _, value in
                let (item, _) = value
                return item
            }
            .eraseToAnyPublisher()
            .sink { [weak self] item in
                item.memo.forEach({ memo in
                    PhotoFileManager.shared.removeImageFromDocument(filename: "\(memo.id)")
                })
                PhotoFileManager.shared.removeImageFromDocument(filename: "\(item.id)")
                self?.repository?.deleteSingleBook(item)
            }
            .store(in: &cancellables)
    }

}

// MARK: - Action
extension BookDetailViewModel {
    enum Action {
        case viewOnAppear(item: (MyBookModel, Bool))
        case modified(item: MyBookModel)
        case deleteButtonTap
    }
    
    func action(_ action: Action) {
        switch action {
        case .viewOnAppear(let item):
            input.viewOnAppear.send((item))
            
        case .modified(let item):
            input.modified.send(item)
            
        case .deleteButtonTap:
            input.deleteButtonTap.send(())
        }
    }
}
