//
//  SearchViewModel.swift
//  CheakBbang
//
//  Created by 박다현 on 9/11/24.
//

import Foundation
import Combine

final class SearchViewModel: ViewModelType {
    var cancellables = Set<AnyCancellable>()
    var input = Input()
    @Published var output = Output()

    
    init() {
        transform()
    }

}

// MARK: - Input / Output
extension SearchViewModel {
    struct Input {
        let searchOnSubmit = PassthroughSubject<String, Never>()
    }
    
    struct Output {
        var bookList: Book = Book(version: "", title: "", link: "", pubDate: "", totalResults: 0, startIndex: 1, itemsPerPage: 1, query: "", searchCategoryID: 1, searchCategoryName: "", item: [])
    }
    
    func transform() {
        input
            .searchOnSubmit
            .sink { [weak self] value in
                Task { [weak self] in
                    await self?.fetchBookList(value)
                }
            }
            .store(in: &cancellables)
    }

    @MainActor
    func fetchBookList(_ search: String) async {
        do {
            let value = try await NetworkManager.shared.callRequest(api: .list(query: search), model: Book.self)
            output.bookList = value
            
        } catch {
            print("Error fetching data: \(error)")
        }
    }
}

// MARK: - Action
extension SearchViewModel {
    enum Action {
        case searchOnSubmit(search: String)
    }
    
    func action(_ action: Action) {
        switch action {
        case .searchOnSubmit(let search):
            input.searchOnSubmit.send(search)
        }
    }
}
