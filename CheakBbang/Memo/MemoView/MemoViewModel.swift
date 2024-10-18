//
//  MemoViewModel.swift
//  CheakBbang
//
//  Created by 박다현 on 9/25/24.
//

import Foundation
import RealmSwift
import Combine
import UIKit


final class MemoViewModel: ViewModelType {
    @ObservedResults(Memo.self) var memoList
    let repsoitory = MyBookRepository()
    var cancellables = Set<AnyCancellable>()
    var input = Input()
    @Published var output = Output()
    
    init() {
        transform()
    }
}

// MARK: - Input / Output
extension MemoViewModel {
    struct Input {
        let viewOnAppear = PassthroughSubject<Memo, Never>()
        let deleteButtonTap = PassthroughSubject<Memo, Never>()
    }
    
    struct Output {
        var memo: Memo = Memo()
        var imageUrl: URL?
        var myBook: MyBook = MyBook()
    }
    
    func transform() {
        input.viewOnAppear
            .sink { [weak self] value in
                guard let self else { return }
                self.output.memo = value
                self.output.imageUrl = PhotoFileManager.shared.loadFileURL(filename: "\(value.id)")
                
                if let book = repsoitory?.fetchSingleItem(self.output.memo.bookId) {
                    self.output.myBook = book
                }
            }
            .store(in: &cancellables)
        
        input.deleteButtonTap
            .sink { [weak self] value in
                guard let self else { return }
                PhotoFileManager.shared.removeImageFromDocument(filename: "\(value.id)")
                $memoList.remove(value)
            }
            .store(in: &cancellables)
    
    }

}

// MARK: - Action
extension MemoViewModel {
    enum Action {
        case viewOnAppear(memo:Memo)
        case deleteButtonTap(memo:Memo)
    }
    
    func action(_ action: Action) {
        switch action {
        case .viewOnAppear(let memo):
            input.viewOnAppear.send(memo)
            
        case .deleteButtonTap(let memo):
            input.deleteButtonTap.send(memo)

        }
    }
}
