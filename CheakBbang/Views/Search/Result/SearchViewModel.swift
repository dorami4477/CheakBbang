//
//  SearchViewModel.swift
//  CheakBbang
//
//  Created by 박다현 on 9/11/24.
//

import Foundation
import Combine
//import Alamofire

final class SearchViewModel: ViewModelType {
    var cancellables = Set<AnyCancellable>()
    var input = Input()
    @Published var output = Output()
    var searchResult: BookDTO? = nil
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
        let loadMoreItems = PassthroughSubject<ItemDTO, Never>()
    }
    
    struct Output {
        var bookList: [ItemDTO] = []
        //var searchFailure: Bool = false
        var searchFailure: String = ""
        var bookListZero: Bool = false
        var isLoading: Bool = false
    }
    
    func transform() {
        
        input.searchOnSubmit
            .flatMap { value in
                return NetworkManager.shared.fetchBookList(value, index: 1)
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let value):
                    self.searchResult = value
                    self.output.isLoading = false
                    
                    if value.item.isEmpty {
                        self.output.bookListZero = true
                    }
                    
                    self.itemCount += value.itemsPerPage

                    if value.startIndex == 1 {
                        self.output.bookList = value.item
                    } else {
                        self.output.bookList.append(contentsOf: value.item)
                    }
                case .failure(let error):
                    self.output.isLoading = false
                    switch error {
                    case .notConnectedToInternet:
                        self.output.searchFailure = "오프라인 상태입니다. 인터넷 연결을 확인하세요."
                    case .timedOut:
                        self.output.searchFailure = "요청 시간이 초과되었습니다. 다시 시도해주세요."
                    case .networkConnectionLost:
                        self.output.searchFailure = "네트워크 연결이 끊어졌습니다. 네트워크를 확인해주세요."
                    case .cannotFindHost, .unknownError:
                        self.output.searchFailure = "알수 없는 네트워크 오류입니다. 잠시 후 다시 시도해주세요."
                    }
                    self.output = self.output
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
        case loadMoreItems(item: ItemDTO)
    }
    
    func action(_ action: Action) {
        switch action {
        case .searchOnSubmit(let search):
            output.bookListZero = false
            output.searchFailure = ""
            input.searchOnSubmit.send(search)
        case .loadMoreItems(let item):
            input.loadMoreItems.send(item)
        }
        
    }
}
