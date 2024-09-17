//
//  Date+.swift
//  CheakBbang
//
//  Created by 박다현 on 9/17/24.
//

import Foundation

extension Date {
    func dateString() -> String {
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "yyyy.MM.dd"
        let savedDateString = myFormatter.string(from: self)
        return savedDateString
    }
}
