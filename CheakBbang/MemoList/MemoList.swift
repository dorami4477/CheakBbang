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
                    Image(ImageName.memoCoverTop)
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width - 16)
                    
                    ForEach(realmMemoList.sorted(by: { $0.date > $1.date }), id:\.id) { memo in
                        NavigationLink {
                            NavigationLazyView(MemoView(viewModel: MemoViewModel(), memo: memo))
                        } label: {
                            listRow(memo)
                        }
                    }
                    Image(ImageName.memoCoverBottom)
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width - 16)
                }
            }
            .navigationTitle("메모 서랍")
            .navigationBarTitleDisplayMode(.inline)
    }
    
    func listRow(_ memo: Memo) -> some View {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(memo.contents)
                        .bold()
                        .lineLimit(3)
                        .truncationMode(.tail)
                        .foregroundStyle(.black)
                        .multilineTextAlignment(.leading)
                    
                    //Text("\(memo.myBook.first?.title ?? "책이름 없음")")
                    Text("\(memo.page == "" ? "전체소감" : memo.page + "p")")
                        .foregroundStyle(.gray)
                        .font(.system(size: 14))
                    Spacer()
                }
                Spacer()
                if let url = PhotoFileManager.shared.loadFileURL(filename: "\(memo.id)") {
                    ImageWrapper(url: url)
                        .frame(width: 110, height: 110)
                        .clipShape(.rect(cornerRadius: 10))
                }
            }
            .padding()
            .frame(height: 142)
            .background {
                Rectangle()
                    .fill(.white)
                    .border(width: 1.9, edges: [.leading, .trailing], color: .black)
                    .border(width: 0.5, edges: [.top], color: .gray.opacity(0.5))
            }
            .overlay {
                Rectangle()
                    .fill(.white)
                    .frame(width: 6, height: 8)
                    .offset(x: -(UIScreen.main.bounds.width / 2 - 18), y: -71)
            }
            .overlay {
                Rectangle()
                    .fill(.white)
                    .frame(width: 6, height: 8)
                    .offset(x: (UIScreen.main.bounds.width / 2 - 18), y: -71)
            }
            .padding(.leading, 8.2)
            .padding(.trailing, 26)
    }
    
}


