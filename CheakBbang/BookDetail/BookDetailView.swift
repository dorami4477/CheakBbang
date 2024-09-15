//
//  BookDetailView.swift
//  CheakBbang
//
//  Created by 박다현 on 9/15/24.
//

import SwiftUI
import RealmSwift

struct BookDetailView: View {
    @ObservedResults(MyBook.self) var bookList
    @Environment(\.dismiss) var dismiss
    
    var item: MyBook
    
    var body: some View {
        Button("책삭제") {
            $bookList.remove(item)
            dismiss()
        }
    }
}

//#Preview {
//    BookDetailView()
//}
