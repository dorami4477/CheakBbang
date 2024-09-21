//
//  AddMemoView.swift
//  CheakBbang
//
//  Created by 박다현 on 9/19/24.
//

import SwiftUI

struct AddMemoView: View {
    @StateObject var viewModel = AddMemoViewModel()
    @Environment(\.dismiss) private var dismiss
    
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
            
//            NavigationLink("cameraTest") {
//                CameraContentView()
//            }
            
            Button(isEditing ? "수정" : "저장") {
                let newMemo = Memo(page: page, title: title, contents: contents, date: Date())
                
                if isEditing {
                    viewModel.action(.editButtonTap(memo: newMemo))
                } else {
                    viewModel.action(.addButtonTap(memo: newMemo))
                }
                
                dismiss()
            }
            .disabled(page.isEmpty)
        }
        .padding()
        .onAppear{
            viewModel.action(.viewOnAppear(item: item, memo: memo ?? Memo()))
        }
    }
}
