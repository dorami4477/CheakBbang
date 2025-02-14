//
//  MemoListViewModel.swift
//  CheakBbang
//
//  Created by 박다현 on 10/21/24.
//

import Combine
import Foundation

import RealmSwift

final class MemoListViewModel: ViewModelType {
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
extension MemoListViewModel {
    struct Input {
        let viewOnAppear = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        var memoList: [MemoModel] = []
    }
    
    func transform() {
        input.viewOnAppear
            .sink { [weak self] book in
                guard let memoList = self?.repository?.fetchMemos() else { return }
                self?.output.memoList = memoList
            }
            .store(in: &cancellables)
    }
    
    
}

// MARK: - Action
extension MemoListViewModel {
    enum Action {
        case viewOnAppear
    }
    
    func action(_ action: Action) {
        switch action {
        case .viewOnAppear:
            input.viewOnAppear.send(())
        }
    }
}

