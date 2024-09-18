//
//  AddBookViewModel.swift
//  CheakBbang
//
//  Created by 박다현 on 9/11/24.
//

import Foundation
import Combine
import RealmSwift

final class AddBookViewModel: ViewModelType {
    @ObservedResults(MyBook.self) var bookList
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
        let addButtonTap = PassthroughSubject<MyBook, Never>()
    }
    
    struct Output {
        var bookItem: Item = Item(title: "", link: "", author: "", pubDate: "", description: "", isbn: "", isbn13: "", itemID: 0, cover: "", categoryID: 0, categoryName: "", publisher: "", adult: true, customerReviewRank: 0, subInfo: SubInfo(subTitle: nil, originalTitle: nil, itemPage: nil))
    }
    
    func transform() {
        input.viewOnTask
            .flatMap { value in
                NetworkManager.shared.fetchSingleBookItem(value)
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error fetching book item: \(error)")
                }
            }, receiveValue: { [weak self] item in
                    self?.output.bookItem = item

            })
            .store(in: &cancellables)
        
        input
            .addButtonTap
            .sink { [weak self] value in
                self?.$bookList.append(value)
            }
            .store(in: &cancellables)
    }

}

// MARK: - Action
extension AddBookViewModel {
    enum Action {
        case viewOnTask(isbn: String)
        case addButtonTap(item: MyBook)
    }
    
    func action(_ action: Action) {
        switch action {
        case .viewOnTask(let isbn):
            input.viewOnTask.send(isbn)
        case .addButtonTap(let item):
            input.addButtonTap.send(item)
        }
    }
}
