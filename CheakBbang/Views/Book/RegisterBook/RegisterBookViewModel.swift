//
//  RegisterBookViewModel.swift
//  CheakBbang
//
//  Created by 박다현 on 12/21/24.
//

import Combine
import SwiftUI

final class RegisterBookViewModel: ViewModelType {
    let repository: BookRepositoryProtocol?
    var cancellables = Set<AnyCancellable>()
    
    var input = Input()
    @Published var output = Output()
    
    var newBook: ((MyBookModel, UIImage) -> Void)?
    
    init(repository: BookRepositoryProtocol?, bookId: String? = nil, book: BookRegInputModel = BookRegInputModel(), review: ReviewRegInputModel = ReviewRegInputModel(), newBook: ((MyBookModel, UIImage) -> Void)?) {
        self.repository = repository
        self.output.bookId = bookId
        self.output.book = book
        self.output.review = review
        self.newBook = newBook

        transform()
    }
}

// MARK: - Input / Output
extension RegisterBookViewModel {
    struct Input {
        let bookCover = PassthroughSubject<UIImage, Never>()
        let createBook = PassthroughSubject<(BookRegInputModel, ReviewRegInputModel), Never>()
    }
    
    struct Output {
        var book: BookRegInputModel = BookRegInputModel()
        var review: ReviewRegInputModel = ReviewRegInputModel()
        var bookId: String? = nil
    }
    
    func transform() {
        input.createBook
            .combineLatest(input.bookCover)
            .sink { [weak self] mybook, cover in
                guard let self else { return }
                let (book, review) = mybook
                let item = BookMapper.toEntity(book: book, review: review)

                if let newItem = repository?.addBook(id: output.bookId, book: item) {
                    PhotoFileManager.shared.saveImageToDocument(image: cover, filename: "\(newItem.id)")
                    newBook?(newItem.toMyBookModel(), cover)
                } else {
                    print("fail to save book")
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Action
extension RegisterBookViewModel {
    enum Action {
        case createBook(book: BookRegInputModel, review: ReviewRegInputModel, cover: UIImage)
    }
    
    func action(_ action: Action) {
        switch action {
        case .createBook(let book, let review, let cover):
            input.createBook.send((book, review))
            input.bookCover.send(cover)
        }
    }
}
