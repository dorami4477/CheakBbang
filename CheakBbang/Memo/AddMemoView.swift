//
//  AddMemoView.swift
//  CheakBbang
//
//  Created by 박다현 on 9/19/24.
//

import SwiftUI
/*
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
            
            NavigationLink("ocrTest") {
                Writer()
            }
            
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
*/
struct AddMemoView: View {    
    @StateObject var viewModel = AddMemoViewModel()
    @Environment(\.dismiss) private var dismiss
    
    @State var item: MyBook
    @State var memo: Memo?
    
    @State private var page: String = ""
    @State private var content: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            HStack(alignment: .top) {
                Text("내용*")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(Color.black)
                    .frame(maxWidth: 70, alignment: .leading)
                
                ZStack(alignment: .topLeading) {
                    TextEditor(text: $content)
                        .background(Color.white)
                        .frame(height: 150)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.accent, lineWidth:5)
                                .frame(height: 150)
                        }
                    
                    if content.isEmpty {
                        Text("메모를 입력하세요.")
                            .foregroundColor(.gray)
                            .padding(12)
                    }
                }
            }
            // 페이지 필드
            HStack(alignment: .top) {
                Text("페이지")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(Color.black)
                    .frame(maxWidth: 70, alignment: .leading)
                
                TextField("페이지", text: $page)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 8)
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 2))
                    .frame(width: 80)
                
                Text("전체 책에 대한 메모라면, 비워주세요!")
                    .foregroundColor(.gray)
                    .font(.system(size: 14))
            }
            
            // 사진 추가
            HStack(alignment: .top) {
                Text("사진")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(Color.black)
                    .frame(maxWidth: 70, alignment: .leading)
                
                HStack(spacing: 5) {
                    // 카메라 버튼
                    Button(action: {

                    }) {
                        Image("icon_camera")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32, height: 32)
                    }
                    
                    // 사진 선택 버튼
                    Button(action: {

                    }) {
                        Image("icon_gallery")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32, height: 32)
                    }
                }
            }
            
            // 저장 버튼
            Button(action: {
                // 저장 동작 추가
            }) {
                Text("저장")
                    .font(.system(size: 18, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                    .background(.accent)
                    .foregroundColor(.white)
                    .clipShape(.capsule)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("메모")
    }
}
