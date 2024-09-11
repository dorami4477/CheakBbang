//
//  AddBookView.swift
//  CheakBbang
//
//  Created by 박다현 on 9/11/24.
//

import SwiftUI

struct AddBookView: View {
    var isbn13: String
    @StateObject var viewModel: AddBookViewModel
    
    var body: some View {
        Text(viewModel.output.bookItem.title)
            .task {
                viewModel.action(.viewOnTask(isbn: isbn13))
            }
    }
}

#Preview {
    AddBookView(isbn13: "9788965966463", viewModel: AddBookViewModel())
}
