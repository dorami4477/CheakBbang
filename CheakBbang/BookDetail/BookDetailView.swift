//
//  BookDetailView.swift
//  CheakBbang
//
//  Created by 박다현 on 9/15/24.
//

import SwiftUI
import RealmSwift

struct BookDetailView: View {
    @StateObject var viewModel = BookDetailViewModel()
   // @Environment(\.dismiss) var dismiss
    
    var item: MyBook
    
    var body: some View {
        Button("-책삭제") {
            viewModel.action(.deleteButtonTap)
          //  dismiss()
        }
        .onAppear{
            viewModel.action(.viewOnAppear(item: item))
        }
    }
}

//#Preview {
//    BookDetailView()
//}
