//
//  EditBookViewModel.swift
//  CheakBbang
//
//  Created by 박다현 on 9/19/24.
//

import Foundation
import Combine
import RealmSwift

final class EditBookViewModel: ViewModelType {
    private var realm: Realm
    var cancellables = Set<AnyCancellable>()
    @Published var input = Input()
    @Published var output = Output()

    
    init() {
        self.realm = try! Realm()
        transform()
    }
}


// MARK: - Input / Output
extension EditBookViewModel {
    struct Input {
        var startDate: Date = Date()
        var endDate: Date = Date()
        var readingState: ReadingState = .finished
        var rating = 3.0
        let viewOnTask = PassthroughSubject<MyBook, Never>()
        let addButtonTap = PassthroughSubject<MyBook, Never>()
    }
    
    struct Output {
    }
    
    func transform() {
        input
            .addButtonTap
            .sink { [weak self] value in
                guard let self else { return }
                let data = realm.object(ofType: MyBook.self, forPrimaryKey: value.id)!
                try! self.realm.write {
                    data.rate = self.input.rating
                    data.status = self.input.readingState
                    data.startDate = self.input.startDate
                    data.endDate = self.input.endDate
                }
            }
            .store(in: &cancellables)
        
        
        input.viewOnTask
            .sink { [weak self] value in
                guard let self else { return }
                self.input.rating = value.rate
                self.input.readingState = value.status
                self.input.startDate = value.startDate
                self.input.endDate = value.endDate
            }
            .store(in: &cancellables)
    }

}

// MARK: - Action
extension EditBookViewModel {
    enum Action {
        case viewOnTask(item: MyBook)
        case addButtonTap(item: MyBook)
    }
    
    func action(_ action: Action) {
        switch action {
        case .viewOnTask(let item):
            input.viewOnTask.send(item)
        case .addButtonTap(let item):
            input.addButtonTap.send(item)
        }
    }
}
