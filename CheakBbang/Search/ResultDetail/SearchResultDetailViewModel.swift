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

    @MainActor
    func fetchBook(_ isbn: String) async {
        do {
            let value = try await NetworkManager.shared.callRequest(api: .item(id: isbn), model: Book.self)
            guard let firstItem = value.item.first else { return }
            output.book = firstItem

        } catch {
            print("Error fetching data: \(error)")
        }
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
