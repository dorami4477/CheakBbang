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
                Image(uiImage: UIImage(contentsOfFile: url.path) ?? UIImage())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            Text("\(Int.random(in: 1...1000))")
            Text(viewModel.output.memo.contents)
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

