//
//  AddMemoViewModel.swift
//  CheakBbang
//
//  Created by 박다현 on 9/21/24.
//

import Combine
import UIKit

import RealmSwift

final class AddMemoViewModel: ViewModelType {
    var item: MyBookModel = MyBook().toMyBookModel()
    var memo: MemoModel = Memo().toMemoModel()
    
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
extension AddMemoViewModel {
    struct Input {
        let viewOnAppear = PassthroughSubject<MyBookModel, Never>()
        let viewOnAppearMemo = PassthroughSubject<MemoModel, Never>()
        let addButtonTap = PassthroughSubject<(Memo, UIImage?), Never>()
        let editButtonTap = PassthroughSubject<(Memo, UIImage?), Never>()
        let deleteButtonTap = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
    }
    
    func transform() {
        input.viewOnAppear
            .sink { [weak self] book in
                self?.item = book
            }
            .store(in: &cancellables)
        
        input.viewOnAppearMemo
            .sink { [weak self] value in
                self?.memo = value
            }
            .store(in: &cancellables)
        
        input.addButtonTap
            .sink { [weak self] (memo, image) in
                self?.repository?.addMemo(memo)
                guard let image else { return }
                PhotoFileManager.shared.saveImageToDocument(image: image, filename: "\(memo.id)")
            }
            .store(in: &cancellables)
        
        input.editButtonTap
            .sink { [weak self] (newMemo, image) in
                guard let self else { return }
                self.repository?.editMemo(id: self.memo.id, newMemo: newMemo)

                guard let image else { return }
                PhotoFileManager.shared.saveImageToDocument(image: image, filename: "\(self.memo.id)")
            }
            .store(in: &cancellables)
        
//        input.deleteButtonTap
//            .sink { [weak self] _ in
//                guard let self else { return }
//            
//                if let _ = self.item.memo.firstIndex(where: { $0.id == self.memo.id }) {
//                    PhotoFileManager.shared.removeImageFromDocument(filename: "\(self.memo.id)")
//                    self.repository?.deleteSingleMemo(self.memo)
//                }
//            }
//            .store(in: &cancellables)
    
    }

}

// MARK: - Action
extension AddMemoViewModel {
    enum Action {
        case viewOnAppear(item: MyBookModel, memo:MemoModel )
        case addButtonTap(memo : Memo, image: UIImage?)
        case editButtonTap(memo : Memo, image: UIImage?)
        case deleteButtonTap
    }
    
    func action(_ action: Action) {
        switch action {
        case .viewOnAppear(let item, let memo):
            input.viewOnAppear.send(item)
            input.viewOnAppearMemo.send(memo)
            
        case .addButtonTap(let memo, let image):
            input.addButtonTap.send((memo, image ?? nil))
            
        case .editButtonTap(let memo, let image):
            input.editButtonTap.send((memo, image ?? nil))
            
        case .deleteButtonTap:
            input.deleteButtonTap.send(())

        }
    }
}
