//
//  AddBookViewModel.swift
//  CheakBbang
//
//  Created by 박다현 on 9/11/24.
//

import Foundation
import Combine
import RealmSwift
import UIKit

final class AddBookViewModel: ViewModelType {
    @ObservedResults(MyBook.self) var bookList
    var cancellables = Set<AnyCancellable>()
    @Published var input = Input()
    @Published var output = Output()
    
    init() {
        transform()
    }
}


// MARK: - Input / Output
extension AddBookViewModel {
    struct Input {
        var startDate: Date = Date()
        var endDate: Date = Date()
        var readingState: ReadingState = .finished
        var rating = 3.0
        let viewOnTask = PassthroughSubject<ItemDTO, Never>()
        let addButtonTap = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        var bookItem: ItemDTO = ItemDTO(title: "", link: "", author: "", pubDate: "", description: "", isbn: "", isbn13: "", itemID: 0, cover: "", categoryID: 0, categoryName: "", publisher: "", adult: true, customerReviewRank: 0, subInfo: SubInfoDTO(subTitle: nil, originalTitle: nil, itemPage: nil))
    }
    
    func transform() {
        input.viewOnTask
            .flatMap{ value in
                NetworkManager.shared.fetchSingleBookItem(value.isbn13)
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
                    print("Error fetching book item: \(error)")
                }
            }, receiveValue: { [weak self] item in
                    self?.output.bookItem = item

            })
            .store(in: &cancellables)


        
        input
            .addButtonTap
            .sink { [weak self] value in
                guard let self else { return }
                let newItem = MyBook(itemId: self.output.bookItem.itemID,
                                     title: self.output.bookItem.title,
                                     originalTitle: self.output.bookItem.subInfo.originalTitle ?? "",
                                     author: self.output.bookItem.author,
                                     publisher: self.output.bookItem.publisher,
                                     pubDate: self.output.bookItem.pubDate,
                                     explanation: self.output.bookItem.description,
                                     cover: self.output.bookItem.cover,
                                     isbn13: self.output.bookItem.isbn13,
                                     rate: self.input.rating,
                                     page: self.output.bookItem.subInfo.itemPage ?? 0,
                                     status: self.input.readingState,
                                     startDate: self.input.startDate,
                                     endDate: self.input.endDate)
                self.$bookList.append(newItem)
                
                PhotoFileManager.shared.saveStringImageToDocument(imageURL: self.output.bookItem.cover, 
                                                                  filename: "\(newItem.id)")
            }
            .store(in: &cancellables)
    }
    

}

// MARK: - Action
extension AddBookViewModel {
    enum Action {
        case viewOnTask(item: ItemDTO)
        case addButtonTap
    }
    
    func action(_ action: Action) {
        switch action {
        case .viewOnTask(let item):
            input.viewOnTask.send(item)
        case .addButtonTap:
            input.addButtonTap.send(())
        }
    }
}
