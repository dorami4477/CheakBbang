//
//  MemoView.swift
//  CheakBbang
//
//  Created by 박다현 on 9/24/24.
//

import SwiftUI
import RealmSwift

struct MemoView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showAlert = false
    @StateObject var viewModel: MemoViewModel
    @ObservedRealmObject var memo: Memo

    var body: some View {
        VStack {
            if let url = viewModel.output.imageUrl {
                let modifiedURL = url.appendingQueryParameter("timestamp", "\(Date().timeIntervalSince1970)")
                ImageWrapper(url: modifiedURL, contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            Text(viewModel.output.memo.contents)
            Text("\(viewModel.output.memo.page == "" ? "전체소감" : viewModel.output.memo.page + "p")")
            Text(viewModel.output.myBook.title)
                .navigationTitle("메모 서랍")
                .navigationBarTitleDisplayMode(.inline)
        }
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                NavigationLink {
                    NavigationLazyView(AddMemoView(item: MyBook(), memo: memo))
                } label: {
                    Image(ImageName.edit)
                        .resizable()
                        .frame(width: 24, height: 24)
                }
                
                Image(ImageName.trash)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .wrapToButton {
                        showAlert = true
                    }
                    .alert("정말 삭제 하시겠습니까?", isPresented: $showAlert) {
                        Button("삭제") {
                            viewModel.action(.deleteButtonTap(memo: memo))
                            dismiss()
                        }
                        Button("취소", role: .cancel) {}
                    }
            }
        }
        .onAppear{
            print("onAppear")
            viewModel.action(.viewOnAppear(memo: memo))
        }
    }
}

