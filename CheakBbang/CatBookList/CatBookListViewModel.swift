//
//  CatBookListViewModel.swift
//  CheakBbang
//
//  Created by 박다현 on 9/13/24.
//

import Foundation
import Combine
import RealmSwift

final class CatBookListViewModel: ViewModelType {
    private let repository = MyBookRepository()
    var cancellables = Set<AnyCancellable>()
    
    var input = Input()
    @Published var output = Output()
    
    init() {
        transform()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
}

// MARK: - Input / Output
extension CatBookListViewModel {
    struct Input {
        let viewOnAppear = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        var bookList: [MyBookDTO] = []
        var totalPage: String = "0"
        var bookCount: Int = 0
        var itemHeight: CGFloat = 0
    }
    
    func transform() {
        input.viewOnAppear
            .sink { [weak self] book in
                guard let bookList = self?.repository?.fetchBooks() else { return }
                self?.output.bookList = bookList.filter({ $0.status == .finished })
                self?.updateOutput()
            }
            .store(in: &cancellables)
    }
    
    private func updateOutput() {
        output.totalPage = output.bookList.getTotalPage()
        output.bookCount = output.bookList.count
        output.itemHeight = (getTotalBookHeight() + getShelfHeight()) - (groupBottomPadding() + CGFloat(output.bookCount * 15))
    }
    
    private func getTotalBookHeight() -> CGFloat {
        var height: CGFloat = 0
        output.bookList.forEach {
            height += bookImageHeight($0.page)
        }
        if output.bookList.count > 0 {
            //고양이 높이
            height += 53
        }
        return height
    }
    
    private func groupBottomPadding() -> CGFloat{
        let padding = (output.bookList.count / 5 ) * 35 + ( output.bookCount % 5 > 0 ? 35 : 0 ) - (output.bookCount > 0 ? 35 : 0)
        return CGFloat(padding)
    }
    
    private func getShelfHeight() -> CGFloat{
        let height = (output.bookList.count / 5 ) * 31 + (output.bookCount > 0 && output.bookCount < 5 ? 31 : 0)
        return CGFloat(height)
    }
    
    func isLeadingAlignment(for index: Int) -> Bool {
        let share = index / 5
        return share % 2 == 0
    }
    
    func bookImageHeight(_ page: Int) -> CGFloat {
        switch page {
        case 0..<100:
            return 28
        case 100..<200:
            return 34
        case 200..<300:
            return 38
        case 300..<400:
            return 44
        case 400...:
            return 51
        default:
            return 30
        }
    }
    
    func bookImage(_ page: Int) -> String {
        let randomColor = Int.random(in: 1...4)
        
        switch page {
        case 0..<100:
            return "book_\(randomColor)_01"
        case 100..<200:
            return "book_\(randomColor)_02"
        case 200..<300:
            return "book_\(randomColor)_03"
        case 300..<400:
            return "book_\(randomColor)_04"
        case 400...:
            return "book_\(randomColor)_05"
        default:
            return "book_\(randomColor)_01"
        }
    }
    
}

// MARK: - Action
extension CatBookListViewModel {
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
