//
//  BookDetailView.swift
//  CheakBbang
//
//  Created by 박다현 on 9/15/24.
//

import SwiftUI
import RealmSwift

struct BookDetailView: View {
    @StateObject var viewModel = BookDetailViewModel()
    @State private var showAlert = false
    @Environment(\.dismiss) private var dismiss

    @State var item: MyBook
    
    var body: some View {
        ScrollView {
            VStack {
                BookDetailTopView(coverUrl: item.cover, title: item.title, ogTitle: item.originalTitle)
                
                Divider()
                    .padding(.vertical)
                
                VStack(spacing: 16) {

                    VStack(spacing: 8) {
                        Image(item.status.imageName)
                            .resizable()
                            .frame(width: 100, height: 23.3)
                        
                        RratingHeartView(rating: $item.rate, isEditable: false)
                            .padding(.bottom, 15)
                        
                        if item.status == .finished {
                            Text("읽은기간")
                                .font(.system(size: 15))
                                .foregroundColor(.gray)
                                .padding(.bottom, -5)
                            
                            Text("\(item.startDate.dateString()) - \(item.endDate.dateString())")
                                .font(.system(size: 15))
                                .foregroundColor(.black)
                                .padding(.bottom, 15)
                            
                        } else if item.status == .ongoing {
                            Text("읽은기간")
                                .font(.system(size: 15))
                                .foregroundColor(.gray)
                                .padding(.bottom, -5)
                            
                            Text("\(item.startDate.dateString()) -")
                                .font(.system(size: 15))
                                .foregroundColor(.black)
                                .padding(.bottom, 15)
                        }
                    }
                    
                    VStack(spacing: 12) {
                        ForEach(item.memo, id:\.id) { memo in
                            QuoteView(memo: memo)
                        }
                    }
                    

                    Button(action: {

                    }) {
                        NavigationLink {
                            NavigationLazyView(AddMemoView(item: item, memo: nil))
                        } label: {
                            Text("글귀 추가 하기")
                                .font(.headline)
                                .padding(.vertical, 10)
                                .padding(.horizontal)
                                .frame(maxWidth: 200)
                                .background(.accent)
                                .foregroundColor(.white)
                                .clipShape(.capsule)
                        }
                    }
                }
                
                Divider()
                    .padding(.vertical)
                
                BookDetailBottomView(item)
                
                Spacer()
            }
            .padding()
        }
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                NavigationLink {
                    EditBookView(book: item, viewModel: EditBookViewModel())
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
                            viewModel.action(.deleteButtonTap)
                            self.item = MyBook()
                            dismiss()
                        }
                        Button("취소", role: .cancel) {}
                    }
            }
        }
        .navigationTitle("도서 상세 정보")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear{
            viewModel.action(.viewOnAppear(item: item))
        }
    }
    
    func BookDetailBottomView(_ item: MyBook) -> some View {
            VStack(alignment: .leading, spacing: 8) {
                BottomRowView(title: "작가", content: item.author)
                BottomRowView(title: "출판사", content: item.publisher)
                BottomRowView(title: "출판일", content: item.pubDate)
                BottomRowView(title: "페이지수", content: "\(item.page)")
                BottomRowView(title: "설명글", content: item.explanation)
            }
            .font(.body)
    }
    
}

struct QuoteView: View {
    var memo: Memo

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(memo.title)
                .font(.body)
                .multilineTextAlignment(.leading)
                
            
            HStack {
                Text("\(memo.page)p")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Spacer()
                
                NavigationLink {
                    NavigationLazyView(AddMemoView(item: MyBook(), memo: memo))
                } label: {
                    Image("icon_edit_small")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
            }
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(.accent, lineWidth: 3)
        )
    }
}

struct BookDetailTopView: View {

    let coverUrl: String
    let title: String
    let ogTitle: String
    
    var body: some View {
        VStack {
            BookCover(coverUrl: coverUrl, size: CGSize(width: 170, height: 209.1))
                .padding(.bottom, 20)
            
            Text(title)
                .frame(maxWidth: .infinity)
                .bold()
                .font(.system(size: 21))
                .multilineTextAlignment(.center)
            
            Text(ogTitle)
                .bold()
                .font(.system(size: 17))
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
        }
    }
}

struct BottomRowView: View {
    let title: String
    let content: String
    
    var body: some View {
        HStack(alignment: .top) {
            Text(title)
                .fontWeight(.medium)
                .foregroundStyle(.gray)
                .frame(maxWidth: 80, alignment: .topLeading)
            Text(content)
                .lineLimit(nil)
        }
    }
}
