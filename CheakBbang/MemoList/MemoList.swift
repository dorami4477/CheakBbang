//
//  MemoList.swift
//  CheakBbang
//
//  Created by 박다현 on 9/23/24.
//

import SwiftUI
import RealmSwift

struct MemoList: View {
    @ObservedResults(Memo.self) var realmMemoList
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(realmMemoList, id:\.id) { memo in
                    NavigationLink {
                        NavigationLazyView(MemoView())
                    } label: {
                        listRow(memo)
                    }
                }
            }
            .padding()
        }
    }
    
    func listRow(_ memo: Memo) -> some View {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(memo.contents)
                        .bold()
                        .lineLimit(3)
                        .truncationMode(.tail)
                    Text("\(memo.myBook.first?.title ?? "책이름 없음")")
                    Text("\(memo.page == "" ? "전체소감" : memo.page + "p")")
                        .foregroundStyle(.gray)
                        .font(.system(size: 14))
                    Spacer()
                }
                .padding(.top, 20)
                .padding(.horizontal, 20)
                Spacer()
                if let url = PhotoFileManager.shared.loadFileURL(filename: "\(memo.id)") {
                    ImageWrapper(url: url)
                        .frame(width: 100, height: 100)
                        .clipShape(.rect(cornerRadius: 10))
                        .padding(20)
                }
            }
            .frame(height: 150)
            .background {
                Rectangle()
                    .fill(.white)
                    .border(width: 2, edges: [.leading, .trailing], color: .black)
                    .border(width: 0.5, edges: [.top], color: .gray.opacity(0.5))
            }
            .overlay {
                Rectangle()
                    .fill(.white)
                    .frame(width: 10, height: 10)
                    .offset(x: -(UIScreen.main.bounds.width / 2 - 16), y: -75)
            }
            .overlay {
                Rectangle()
                    .fill(.white)
                    .frame(width: 10, height: 10)
                    .offset(x: (UIScreen.main.bounds.width / 2 - 16), y: -75)
            }
    }
    
}


