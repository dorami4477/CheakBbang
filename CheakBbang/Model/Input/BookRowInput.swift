//
//  BookRowInput.swift
//  CheakBbang
//
//  Created by 박다현 on 2/5/25.
//
import SwiftUI

struct BookRowInput {
    var item: MyBookModel
    var align: Alignment
    var padding: Edge.Set
    var isFirst: Bool
    var isLast: Bool
    var isToy: Bool
    var level: Int
    var toy: UIImage?
}
