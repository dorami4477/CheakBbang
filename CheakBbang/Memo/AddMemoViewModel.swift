//
//  AddMemoViewModel.swift
//  CheakBbang
//
//  Created by 박다현 on 9/21/24.
//

import Foundation
import RealmSwift
import Combine

final class AddMemoViewModel: ViewModelType {
    @ObservedRealmObject var item: MyBook = MyBook()
    let repository = MyBookRepository()
    var cancellables = Set<AnyCancellable>()
    var input = Input()
    @Published var output = Output()
    
    init() {
        transform()
    }
}

// MARK: - Input / Output
extension AddMemoViewModel {
    struct Input {
        let viewOnAppear = PassthroughSubject<MyBook, Never>()
        let addButtonTap = PassthroughSubject<Memo, Never>()
    }
    
    struct Output {
    }
    
    func transform() {
        input.viewOnAppear
            .sink { [weak self] book in
                guard let self else { return }
                item = self.repository?.fetchSingleItem(book.id) ?? MyBook()
                print(item)
            }
            .store(in: &cancellables)
        
        input.addButtonTap
            .sink { [weak self] item in
                self?.$item.memo.append(item)
            }
            .store(in: &cancellables)
    }

}

// MARK: - Action
extension AddMemoViewModel {
    enum Action {
        case viewOnAppear(item: MyBook)
        case addButtonTap(memo : Memo)
    }
    
    func action(_ action: Action) {
        switch action {
        case .viewOnAppear(let item):
            input.viewOnAppear.send(item)
            
        case .addButtonTap(let memo):
            input.addButtonTap.send(memo)
        }
    }
}
