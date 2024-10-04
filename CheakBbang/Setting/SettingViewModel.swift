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
    @ObservedResults(MyBook.self) var realmBookList
    @ObservedResults(Memo.self) var realmMemoList
    var cancellables = Set<AnyCancellable>()
    var input = Input()
    @Published var output = Output()
    
    init() {
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
        var totalPage: String = ""
        var MemoCount: Int = 0
        var bookCount: Int = 0
        var version: String = ""
        var memoPharse: String = ""
    }
    
    func transform() {
        input.viewOnAppear
            .sink { [weak self] _ in
                self?.updateOutput()
            }
            .store(in: &cancellables)
    }
    
    func updateOutput() {
        output.totalPage = getTotalPage()
        output.bookCount = realmBookList.filter({ $0.status == .finished }).count
        output.MemoCount = realmMemoList.count
        output.version = "\(AppVersionManager.shared.version) (\(AppVersionManager.shared.shouldUpdate() ? "업데이트 필요" :"최신 버전"))"
        output.nickName = UserDefaults.standard.string(forKey: "nickName") ?? "냥이 이름을 설정해주세요!"
        output.memoPharse = realmMemoList.randomElement()?.contents ?? "메모를 등록해주세요:)"
    }
    
    func getTotalPage() -> String {
        let number = realmBookList.filter({ $0.status == .finished }).reduce(0) { $0 + $1.page }
        if number >= 1_000_000 {
            let formattedNumber = Double(number) / 1_000_000
            return String(format: "%.1fM", formattedNumber)
        } else if number >= 10_000 {
            let formattedNumber = Double(number) / 1_000
            return String(format: "%.1fK", formattedNumber)
        } else {
            return number.formatted()
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
