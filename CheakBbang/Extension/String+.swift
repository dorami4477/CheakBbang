//
//  String+.swift
//  CheakBbang
//
//  Created by 박다현 on 9/12/24.
//

import Foundation

extension String {
    func truncate(length: Int, trailing: String = "…") -> String {
      return (self.count > length) ? self.prefix(length) + trailing : self
    }
}
