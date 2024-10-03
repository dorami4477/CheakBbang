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
    @ObservedResults(MyBook.self) var realmBookList
    
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

    }
    
    struct Output {
        var bookList: [MyBook] = []
        var totalPage: String = "0"
        var bookCount: Int = 0
        var groupBottomPadding: CGFloat = 0
        var totalBookHeight: CGFloat = 0
        var shelfHeight: CGFloat = 0
        var itemHeight: CGFloat = 0
    }
    
    func transform() {    
        realmBookList.collectionPublisher
            .map { Array($0) }
            .sink(receiveCompletion: { completion in
                print(completion)
            }, receiveValue: { [weak self] books in
                guard let self = self else { return }
                self.output.bookList = books.filter({ $0.status == .finished })
                self.updateOutput()
            })
            .store(in: &cancellables)
    }
    
    private func updateOutput() {
        output.totalPage = getTotalPage()
        output.bookCount = output.bookList.count
        output.groupBottomPadding = groupBottomPadding()
        output.totalBookHeight = getTotalBookHeight()
        output.shelfHeight = getShelfHeight()
        output.itemHeight = (output.totalBookHeight + output.shelfHeight) - (output.groupBottomPadding + CGFloat(output.bookCount * 15))
    }
    
    func getTotalPage() -> String {
        let number = output.bookList.reduce(0) { $0 + $1.page }
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
    
    func dataString(date: Date) -> String {
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "yyyyMMddHHmmss"
        let savedDateString = myFormatter.string(from: date)
        return savedDateString
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
    
    func getTotalBookHeight() -> CGFloat {
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
    
    func groupBottomPadding() -> CGFloat{
        let padding = (output.bookList.count / 5 ) * 35 + ( output.bookCount % 5 > 0 ? 35 : 0 ) - (output.bookCount > 0 ? 35 : 0) 
        return CGFloat(padding)
    }
    
    func getShelfHeight() -> CGFloat{
        let height = (output.bookList.count / 5 ) * 31 + (output.bookCount > 0 && output.bookCount < 5 ? 31 : 0)
        return CGFloat(height)
    }
}

// MARK: - Action
extension CatBookListViewModel {
    enum Action {
    }
    
    func action(_ action: Action) {

    }
}
