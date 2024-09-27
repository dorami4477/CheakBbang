//
//  SearchResultDetailViewModel.swift
//  CheakBbang
//
//  Created by 박다현 on 9/18/24.
//

import Foundation
import Combine

final class SearchResultDetailViewModel: ViewModelType {
    var cancellables = Set<AnyCancellable>()
    var input = Input()
    @Published var output = Output()
    
    init() {
        transform()
    }

}

// MARK: - Input / Output
extension SearchResultDetailViewModel {
    struct Input {
        let viewOnTask = PassthroughSubject<String, Never>()
    }
    
    struct Output {
        var book: Item = Item(title: "", link: "", author: "", pubDate: "", description: "", isbn: "", isbn13: "", itemID: 0, cover: "", categoryID: 0, categoryName: "", publisher: "", adult: true, customerReviewRank: 0, subInfo: SubInfo(subTitle: nil, originalTitle: nil, itemPage: nil))
        var notFoundItem = false
    }
    
 
    func transform() {
        input.viewOnTask
            .flatMap { value in
                NetworkManager.shared.fetchSingleBookItem(value)
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.output.notFoundItem = true
                    print("Error fetching book item: \(error)")
                }
            }, receiveValue: { [weak self] item in
                    self?.output.book = item
            })
            .store(in: &cancellables)
        
    }

}

// MARK: - Action
extension SearchResultDetailViewModel {
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

