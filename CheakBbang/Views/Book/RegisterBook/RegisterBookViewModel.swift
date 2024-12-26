//
//  RegisterBookViewModel.swift
//  CheakBbang
//
//  Created by 박다현 on 12/21/24.
//

import SwiftUI
import Combine

final class RegisterBookViewModel: ViewModelType {
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
extension RegisterBookViewModel {
    struct Input {
        let bookCover = PassthroughSubject<Image, Never>()
        let createBook = PassthroughSubject<MyBook, Never>()
    }
    
    struct Output {
        var book: MyBookModel = MyBook().toMyBookModel()
    }
    
    func transform() {
        input.createBook
            .combineLatest(input.bookCover)
            .sink { [weak self] book, cover in
                guard let self else { return }
                repository?.addBook(book: book)
                if let uiImage = cover.asUIImage() {
                    PhotoFileManager.shared.saveImageToDocument(image: uiImage, filename: "\(book.id)")
                }
            }
            .store(in: &cancellables)
    }

}

// MARK: - Action
extension RegisterBookViewModel {
    enum Action {
        case createBook(book: BookRegInputModel, review: ReviewRegInputModel, cover: Image)
    }
    
    func action(_ action: Action) {
        switch action {
        case .createBook(let book, let review, let cover):
            let newItem = MyBook(itemId: Int(book.isbn13)!,
                                 title: book.title,
                                 originalTitle: "",
                                 author: book.author,
                                 publisher: book.publisher,
                                 pubDate: "",
                                 explanation: "",
                                 cover: "",
                                 isbn13: book.isbn13,
                                 rate: review.rating,
                                 page: Int(book.page)!,
                                 status: review.readingState,
                                 startDate: review.startDate,
                                 endDate: review.endDate)
            input.createBook.send(newItem)
            input.bookCover.send(cover)
        }
    }
}
