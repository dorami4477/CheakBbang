//
//  AddMemoView.swift
//  CheakBbang
//
//  Created by 박다현 on 9/19/24.
//

import SwiftUI
import RealmSwift

struct AddMemoView: View {
    @StateObject var viewModel = AddMemoViewModel()
    
    @State var item: MyBook
    @State var memo: Memo?
    @State private var page: String = ""
    @State private var title: String = ""
    @State private var contents: String = ""

    var isEditing: Bool {
        return memo != nil
    }

    var body: some View {
        VStack {
            TextField("페이지", text: $page)
                .onAppear {
                    if let memo {
                        page = memo.page
                    }
                }
            
            TextField("제목", text: $title)
                .onAppear {
                    if let memo {
                        title = memo.title
                    }
                }
            
            TextField("내용", text: $contents)
                .onAppear {
                    if let memo {
                        contents = memo.contents ?? ""
                    }
                }
            
            NavigationLink("ocrTest") {
                OCRView()
            }
            
            Button(isEditing ? "수정" : "저장") {
                if isEditing {
                    let thawedMemo = memo?.thaw() ?? memo
                    try? thawedMemo?.realm?.write {
                        thawedMemo?.page = page
                        thawedMemo?.title = title
                        thawedMemo?.contents = contents.isEmpty ? nil : contents
                    }
                    
                } else {
                    let newMemo = Memo(page: page, title: title, contents: contents, date: Date())
                    viewModel.action(.addButtonTap(memo: newMemo))
                }
            }
            .disabled(page.isEmpty)
        }
        .padding()
        .onAppear{
            viewModel.action(.viewOnAppear(item: item))
        }
    }
}

//struct AddMemoView: View {
//    @State var item: MyBook = MyBook()
//    let repository = MyBookRepository()
//    @State var memo: Memo?
//    
//    var body: some View {
//        Button("저장") {
//            let newMemo = Memo(page: "page", title: "title", contents: "contents", date: Date())
//            repository?.createMemo(book: item, data: newMemo)
//            item = MyBook()
//            memo = nil
//        }
//    }
//}
