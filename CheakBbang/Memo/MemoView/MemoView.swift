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
        ScrollView {
            VStack {
                ImageWrapper(name: ImageName.memoViewTop)
                    .padding(.top, 20)
                
                Text(viewModel.output.memo.contents)
                    .bold()
                    .font(.custom("BinggraeII", size: 23))
                    .padding(.horizontal, 22)
                
                ImageWrapper(name: ImageName.memoViewMiddle)
                
                if let url = viewModel.output.imageUrl {
                    let modifiedURL = url.appendingQueryParameter("timestamp", "\(Date().timeIntervalSince1970)")
                    AsyncImageWrapper(url: modifiedURL, contentMode: .fit)
                        .frame(maxWidth: .infinity)
                }
                
                VStack {
                    Text(viewModel.output.myBook.title)
                        .foregroundStyle(.gray)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("\(viewModel.output.memo.page == "" ? "소감" : viewModel.output.memo.page + "p")")
                        .foregroundStyle(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(viewModel.output.memo.date.dateString())
                        .foregroundStyle(.accent)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
                
                ImageWrapper(name: ImageName.memoViewBottom)
                
            }
        }
        .navigationTitle("메모 상세")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                NavigationLink {
                    NavigationLazyView(AddMemoView(viewModel: AddMemoViewModel(), item: MyBook().toMyBookDTO(), memo: memo))
                } label: {
                    ImageWrapper(name: ImageName.edit)
                        .frame(width: 24, height: 24)
                }
                
                ImageWrapper(name: ImageName.trash)
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
        .toolbar(.hidden, for: .tabBar)
        .onAppear{
            viewModel.action(.viewOnAppear(memo: memo))
        }
    }
}
