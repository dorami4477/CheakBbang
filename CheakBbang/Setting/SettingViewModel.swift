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

    }
    
    struct Output {
        var totalPage: String = ""
        var MemoCount: Int = 0
        var bookCount: Int = 0
    }
    
    func transform() {
        let totalPage = realmBookList.reduce(0) { $0 + $1.page }
        output.totalPage = totalPage.formatted()
        output.bookCount = realmBookList.count
        output.MemoCount = realmMemoList.count
    }

}

// MARK: - Action
extension SettingViewModel {
    enum Action {
    }
    
    func action(_ action: Action) {

    }
}
