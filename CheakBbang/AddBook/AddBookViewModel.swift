//
//  AddBookViewModel.swift
//  CheakBbang
//
//  Created by 박다현 on 9/11/24.
//

import Foundation
import Combine

final class AddBookViewModel: ViewModelType {
    var cancellables = Set<AnyCancellable>()
    var input = Input()
    @Published var output = Output()
    
    init() {
        transform()
    }
}


// MARK: - Input / Output
extension AddBookViewModel {
    struct Input {
        let viewOnTask = PassthroughSubject<String, Never>()
    }
    
    struct Output {
        var bookItem: Book = Book(version: "", title: "", link: "", pubDate: "", totalResults: 1, startIndex: 1, itemsPerPage: 1, query: "", searchCategoryID: 1, searchCategoryName: "", item: [])
    }
    
    func transform() {
        input
            .viewOnTask
            .sink { [weak self] value in
                Task { [weak self] in
                    await self?.fetchBook(value)
                }
            }
            .store(in: &cancellables)
    }

    
    func fetchBook(_ isbn: String) async {
        do {
            let value = try await NetworkManager.shared.callRequest(api: .item(id: isbn), model: Book.self)
            output.bookItem = value
            
        } catch {
            print("Error fetching data: \(error)")
        }
    }
}

// MARK: - Action
extension AddBookViewModel {
    enum Action {
        case viewOnTask(isbn: String)
    }
    
    func action(_ action: Action) {
        switch action {
        case .viewOnTask(let isbn):
            input.viewOnTask.send(isbn)
        }
    }
}
