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
    var searchResult: Book? = nil
    var searchTerm = ""
    var itemCount = 0
    
    init() {
        transform()
    }

}

// MARK: - Input / Output
extension SearchViewModel {
    struct Input {
        let searchOnSubmit = PassthroughSubject<String, Never>()
        let loadMoreItems = PassthroughSubject<Item, Never>()
    }
    
    struct Output {
        var bookList: [Item] = []
        var searchFailure: Bool = false
        var bookListZero: Bool = false
        var isLoading: Bool = false
    }
    
    func transform() {
        
        input.searchOnSubmit
            .flatMap { [weak self] value in
                guard let self else {
                    return Empty<Book, Error>().eraseToAnyPublisher()
                }
                return NetworkManager.shared.fetchBookList(value, index: self.itemCount + 1)
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.output.searchFailure = true
                    print("Error fetching book item: \(error)")
                }
            }, receiveValue: { [weak self] value in
                guard let self else { return }
                searchResult = value
                output.isLoading = false
                
                if value.item.isEmpty {
                    output.bookListZero = true
                }
                
                self.itemCount += value.itemsPerPage

                if value.startIndex == 1 {
                    self.output.bookList = value.item
                } else {
                    self.output.bookList.append(contentsOf: value.item)
                }

            })
            .store(in: &cancellables)
        
        input
            .loadMoreItems
            .sink { [weak self] item in
                Task { [weak self] in
                    guard let self else { return }
                    guard let searchResult = self.searchResult else { return }
                    if self.output.bookList.last == item && searchResult.totalResults != itemCount {
                        //await self.fetchBookList(searchTerm, index: itemCount + 1)
                    }
                }
            }
            .store(in: &cancellables)
    }

}

// MARK: - Action
extension SearchViewModel {
    enum Action {
        case searchOnSubmit(search: String)
        case loadMoreItems(item: Item)
    }
    
    func action(_ action: Action) {
        switch action {
        case .searchOnSubmit(let search):
            output.bookListZero = false
            output.searchFailure = false
            input.searchOnSubmit.send(search)
        case .loadMoreItems(let item):
            input.loadMoreItems.send(item)
        }
        
    }
}
