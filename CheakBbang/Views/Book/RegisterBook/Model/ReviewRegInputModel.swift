//
//  ReviewRegInputModel.swift
//  CheakBbang
//
//  Created by 박다현 on 12/26/24.
//

import Foundation

struct ReviewRegInputModel {
    var startDate: Date = Date()
    var endDate: Date = Date()
    var readingState: ReadingState = .finished
    var rating = 3.0
}
