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
    private let repository: MemoRepositoryProtocol?
    var cancellables = Set<AnyCancellable>()
    var input = Input()
    @Published var output = Output()
    
    init(repository: MemoRepositoryProtocol?) {
        self.repository = repository
        transform()
    }
}

// MARK: - Input / Output
extension MemoViewModel {
    struct Input {
        let viewOnAppear = PassthroughSubject<MemoDTO, Never>()
        let deleteButtonTap = PassthroughSubject<MemoDTO, Never>()
    }
    
    struct Output {
        var memo: MemoDTO = Memo().toMemoDTO()
        var imageUrl: URL?
        var myBook: MyBookDTO = MyBook().toMyBookDTO()
    }
    
    func transform() {
        input.viewOnAppear
            .sink { [weak self] value in
                guard let self else { return }
                guard let memo = self.repository?.fetchSingleMemo(value.id) else { return }
                self.output.memo = memo
                self.output.imageUrl = PhotoFileManager.shared.loadFileURL(filename: "\(value.id)")
                if let book = self.repository?.fetchSingleBook(self.output.memo.bookId) {
                    self.output.myBook = book
                }
            }
            .store(in: &cancellables)
        
        input.deleteButtonTap
            .sink { [weak self] value in
                guard let self else { return }
                PhotoFileManager.shared.removeImageFromDocument(filename: "\(value.id)")
                self.repository?.deleteSingleMemo(value)
            }
            .store(in: &cancellables)
    
    }

}

// MARK: - Action
extension MemoViewModel {
    enum Action {
        case viewOnAppear(memo:MemoDTO)
        case deleteButtonTap(memo:MemoDTO)
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
