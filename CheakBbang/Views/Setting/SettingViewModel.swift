//
//  SettingViewModel.swift
//  CheakBbang
//
//  Created by 박다현 on 9/28/24.
//

import Foundation
import Combine
import RealmSwift

final class SettingViewModel: ViewModelType {
    private let repository: BookRepositoryProtocol?
    var cancellables = Set<AnyCancellable>()
    
    private var bookList: [MyBookModel] = []
    private var memoList: [MemoModel] = []
    
    var input = Input()
    @Published var output = Output()
    
    init(repository: BookRepositoryProtocol?) {
        self.repository = repository
        transform()
    }
}

// MARK: - Input / Output
extension SettingViewModel {
    struct Input {
        let viewOnAppear = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        var nickName: String = ""
        var totalPage: String = "0"
        var MemoCount: Int = 0
        var bookCount: Int = 0
        var version: String = ""
        var memoPharse: String = ""
    }
    
    func transform() {
        input.viewOnAppear
            .sink { [weak self] book in
                guard let bookList = self?.repository?.fetchBooks() else { return }
                guard let memoList = self?.repository?.fetchMemos() else { return }
                self?.bookList = bookList
                self?.memoList = memoList
                self?.updateOutput()
            }
            .store(in: &cancellables)
    }
    
    private func updateOutput() {
        output.totalPage = bookList.filter({ $0.status == .finished }).getTotalPage()
        output.bookCount = bookList.filter({ $0.status == .finished }).count
        output.MemoCount = memoList.count
        output.nickName = UserDefaults.standard.string(forKey: "nickName") ?? "냥이 이름을 설정해주세요!"
        output.memoPharse = memoList.randomElement()?.contents ?? "메모를 등록해주세요. \n랜덤으로 등록된 메모가 보여요!"
        AppVersionManager.shared.shouldUpdate { [weak self] needUpdate in
            DispatchQueue.main.async {
                self?.output.version = "\(AppVersionManager.shared.version) (\(needUpdate ? "업데이트 필요" :"최신 버전"))"
            }
        }
    }
    
}

// MARK: - Action
extension SettingViewModel {
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
