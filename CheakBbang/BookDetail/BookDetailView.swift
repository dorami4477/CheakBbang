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
                        
                        HStack(spacing: 0) {
                            ForEach(0..<5) { index in
                                Image(systemName: Double(index) < item.rate ? "heart.fill" : "heart")
                                    .foregroundColor(Double(index) < item.rate ? .accent : .gray)
                            }
                        }
                        
                        
                        Text("읽은기간")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.bottom, -5)
                        
                        Text("\(item.startDate.dateString()) - \(item.endDate.dateString())")
                            .font(.system(size: 15))
                            .foregroundColor(.black)
                    }
                    
                    VStack(spacing: 12) {
                        QuoteView(text: "돈, 그것은 나의 걱정을 모두 사라지게 했다. 월 1억은 쉽지!", page: "128p")
                        QuoteView(text: "어느날 서랍을 열어보니, 불안 대신에 돈이 가득 들어있는게 아닌가!! 놀란 나는 춤을 췄다.", page: "327p")
                    }
                    

                    Button(action: {

                    }) {
                        Text("글귀 추가 하기")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: 200)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .clipShape(.capsule)
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
                Image(ImageName.edit)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .wrapToButton {
                        viewModel.action(.deleteButtonTap)
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
    var text: String
    var page: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(text)
                .font(.body)
                .multilineTextAlignment(.leading)
                
            
            HStack {
                Text(page)
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Spacer()
                
                NavigationLink {
        
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
                .stroke(Color.orange, lineWidth: 3)
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
                .font(.title3)
                .multilineTextAlignment(.center)
            
            Text(ogTitle)
                .bold()
                .font(.title3)
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
