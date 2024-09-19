//
//  ReadingState.swift
//  CheakBbang
//
//  Created by 박다현 on 9/17/24.
//

import Foundation
import RealmSwift

enum ReadingState: String, CaseIterable, PersistableEnum {
    case finished = "읽은 책"
    case ongoing = "읽고 있는 책"
    case upcoming = "읽을 책"
    
    var imageName: String {
        switch self {
        case .finished:
            "icon_progress_finish"
            
        case .ongoing:
            "icon_progress_ongoing"
            
        case .upcoming:
            "icon_progress_upcoming"
        }
    }
}

