//
//  EditBookViewModel.swift
//  CheakBbang
//
//  Created by 박다현 on 9/19/24.
//

import Combine
import Foundation

import RealmSwift

final class EditBookViewModel: ViewModelType {
    private let repository: BookRepositoryProtocol?
    var cancellables = Set<AnyCancellable>()
    @Published var input = Input()
    @Published var output = Output()

    
    init(repository: BookRepositoryProtocol?) {
        self.repository = repository
        transform()
    }
}


// MARK: - Input / Output
extension EditBookViewModel {
    struct Input {
        var startDate: Date = Date()
        var endDate: Date = Date()
        var readingState: ReadingState = .finished
        var rating = 3.0
        let viewOnTask = PassthroughSubject<MyBookModel, Never>()
        let addButtonTap = PassthroughSubject<MyBookModel, Never>()
    }
    
    struct Output {
    }
    
    func transform() {
        input
            .addButtonTap
            .sink { [weak self] value in
                guard let self else { return }
                repository?.editBookReview(value.id, rate: self.input.rating, status: self.input.readingState, startDate: self.input.startDate, endDate: self.input.endDate)
            }
            .store(in: &cancellables)
        
        
        input.viewOnTask
            .sink { [weak self] value in
                guard let self else { return }
                if let bookData = self.repository?.fetchSingleBookModel(value.id) {
                    self.input.rating = bookData.rate
                    self.input.readingState = bookData.status
                    self.input.startDate = bookData.startDate
                    self.input.endDate = bookData.endDate
                }
            }
            .store(in: &cancellables)
    }

}

// MARK: - Action
extension EditBookViewModel {
    enum Action {
        case viewOnTask(item: MyBookModel)
        case addButtonTap(item: MyBookModel)
    }
    
    func action(_ action: Action) {
        switch action {
        case .viewOnTask(let item):
            input.viewOnTask.send(item)
        case .addButtonTap(let item):
            input.addButtonTap.send(item)
        }
    }
}
