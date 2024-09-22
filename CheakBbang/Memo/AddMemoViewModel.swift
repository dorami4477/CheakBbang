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
    @ObservedRealmObject var memo: Memo = Memo()
    
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
        let viewOnAppearMemo = PassthroughSubject<Memo, Never>()
        let addButtonTap = PassthroughSubject<Memo, Never>()
        let editButtonTap = PassthroughSubject<Memo, Never>()
        let deleteButtonTap = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
    }
    
    func transform() {
        input.viewOnAppear
            .sink { [weak self] book in
                guard let self else { return }
                item = book
            }
            .store(in: &cancellables)
        
        input.viewOnAppearMemo
            .sink { [weak self] value in
                self?.memo = value
            }
            .store(in: &cancellables)
        
        input.addButtonTap
            .sink { [weak self] item in
                self?.$item.memo.append(item)
            }
            .store(in: &cancellables)
        
        input.editButtonTap
            .sink { [weak self] item in
                self?.$memo.page.wrappedValue = item.page
                self?.$memo.title.wrappedValue = item.title
                self?.$memo.contents.wrappedValue = item.contents
            }
            .store(in: &cancellables)
        
        input.deleteButtonTap
            .sink { [weak self] _ in
                guard let self else { return }
            
                if let index = self.item.memo.firstIndex(where: { $0.id == self.memo.id }) {
                    $item.memo.remove(at: index)
                }
            }
            .store(in: &cancellables)
    
    }

}

// MARK: - Action
extension AddMemoViewModel {
    enum Action {
        case viewOnAppear(item: MyBook, memo:Memo)
        case addButtonTap(memo : Memo)
        case editButtonTap(memo : Memo)
        case deleteButtonTap
    }
    
    func action(_ action: Action) {
        switch action {
        case .viewOnAppear(let item, let memo):
            input.viewOnAppear.send(item)
            input.viewOnAppearMemo.send(memo)
            
        case .addButtonTap(let memo):
            input.addButtonTap.send(memo)
            
        case .editButtonTap(let memo):
            input.editButtonTap.send(memo)
            
        case .deleteButtonTap:
            input.deleteButtonTap.send(())
        }
    }
}
