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
        let viewOnTask = PassthroughSubject<ItemDTO, Never>()
    }
    
    struct Output {
        var book: ItemDTO = ItemDTO(title: "", link: "", author: "", pubDate: "", description: "", isbn: "", isbn13: "", itemID: 0, cover: "", categoryID: 0, categoryName: "", publisher: "", adult: true, customerReviewRank: 0, subInfo: SubInfoDTO(subTitle: nil, originalTitle: nil, itemPage: nil))
    }
    

    func transform() {
        input.viewOnTask
            .flatMap { value in
                return NetworkManager.shared.fetchSingleBookItem(value.isbn13)
                    .catch { error -> Just<ItemDTO> in
                        return Just(value)
                    }
                    .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Unexpected error: \(error)")
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
        case viewOnTask(item: ItemDTO)
    }
    
    func action(_ action: Action) {
        switch action {
        case .viewOnTask(let item):
            input.viewOnTask.send(item)
        }
    }
}

