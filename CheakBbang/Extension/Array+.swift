//
//  Array+.swift
//  CheakBbang
//
//  Created by 박다현 on 10/14/24.
//

import Foundation

extension Array where Element == MyBookModel {
    func getTotalPage() -> String {
        let number = self.reduce(0) { $0 + $1.page }
        
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
