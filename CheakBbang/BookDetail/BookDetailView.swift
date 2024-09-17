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

    var item: MyBook
    
    var body: some View {
        ScrollView {
            VStack {
                BookCover(coverUrl: item.cover, size: CGSize(width: 170, height: 209.1))
                    .padding(.bottom, 20)
                
                Text(item.title)
                    .frame(maxWidth: .infinity)
                    .bold()
                    .font(.title3)
                    .multilineTextAlignment(.center)
                
                
                
                Text(item.originalTitle)
                    .bold()
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                
                Divider()
                    .padding(.vertical)
                
                VStack(spacing: 16) {

                    VStack(spacing: 8) {
                        Image(getReadState(item.status).imageName)
                            .resizable()
                            .frame(width: 100, height: 23.3)
                        
                        HStack(spacing: 0) {
                            ForEach(0..<5) { index in
                                Image(systemName: index < item.rank ? "heart.fill" : "heart")
                                    .foregroundColor(index < item.rank ? .accent : .gray)
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
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack(alignment: .top) {
                        Text("작가")
                            .fontWeight(.medium)
                            .foregroundStyle(.gray)
                            .frame(maxWidth: 80, alignment: .topLeading)
                        Text(item.author)
                    }
                    
                    HStack(alignment: .top) {
                        Text("출판사")
                            .fontWeight(.medium)
                            .foregroundStyle(.gray)
                            .frame(maxWidth: 80, alignment: .topLeading)
                        Text(item.publisher)
                    }
                    
                    HStack(alignment: .top) {
                        Text("출판일")
                            .fontWeight(.medium)
                            .foregroundStyle(.gray)
                            .frame(maxWidth: 80, alignment: .topLeading)
                        Text(item.pubDate)
                    }
                    
                    HStack(alignment: .top) {
                        Text("페이지수")
                            .fontWeight(.medium)
                            .foregroundStyle(.gray)
                            .frame(maxWidth: 80, alignment: .topLeading)
                        Text("\(item.page)")
                    }
                    
                    HStack(alignment: .top) {
                        Text("설명글")
                            .fontWeight(.medium)
                            .foregroundStyle(.gray)
                            .frame(maxWidth: 80, alignment: .topLeading)
                        Text(item.explanation)
                            .lineLimit(nil)
                    }
                }
                .font(.body)
                
                Spacer()
            }
            .padding()
        }
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Image("icon_edit")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .wrapToButton {
                        viewModel.action(.deleteButtonTap)
                    }
                Image("icon_trach")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .wrapToButton {
                        viewModel.action(.deleteButtonTap)
                    }
            }
        }
        .navigationTitle("도서 상세 정보")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear{
            viewModel.action(.viewOnAppear(item: item))
        }
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
