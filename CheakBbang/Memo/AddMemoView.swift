//
//  AddMemoView.swift
//  CheakBbang
//
//  Created by 박다현 on 9/19/24.
//

import SwiftUI
import RealmSwift

struct AddMemoView: View {
    @ObservedRealmObject var item: MyBook
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
                    //if memo.title != "" {
                        page = memo.page
                    }
                }
            
            TextField("제목", text: $title)
                .onAppear {
                    if let memo {
                    //if memo.title != "" {
                        title = memo.title
                    }
                }
            
            TextField("내용", text: $contents)
                .onAppear {
                    if let memo {
                    //if memo.title != "" {
                        contents = memo.contents ?? ""
                    }
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
                    $item.memo.append(newMemo)
                }
            }
            .disabled(page.isEmpty)
        }
        .padding()
    }
}
