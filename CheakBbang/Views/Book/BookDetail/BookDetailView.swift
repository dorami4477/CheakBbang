//
//  BookDetailView.swift
//  CheakBbang
//
//  Created by 박다현 on 9/15/24.
//

import SwiftUI
import RealmSwift
import Combine

struct BookDetailView: View {
    @StateObject var viewModel: BookDetailViewModel
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.presentationMode) var presentationMode
    @State var cancellables = Set<AnyCancellable>()
    
    @State private var showAlert = false
    @State private var isEditted = false
    
    @State var bookCover: UIImage? = nil
    @State var item: MyBookModel
    
    var body: some View {
        ScrollView {
            VStack {
                BookCoverInfoView(bookId: "\(item.id)", coverUrl: item.cover, title: item.title, ogTitle: item.originalTitle, bookCover: bookCover)

                Divider()
                    .padding(.vertical)
                
                VStack(spacing: 16) {
                    ReadingStatusView(item: viewModel.output.book)
                    
                    MemoList(viewModel: MemoListViewModel(repository: MyMemoRepository()), bookID: "\(item.id)", isBookDetailView: true)
                        .padding(.horizontal, -16)
                    
                    NavigationLink {
                        NavigationLazyView(AddMemoView(viewModel: AddMemoViewModel(repository: MyMemoRepository()), item: item, memo: nil))
                    } label: {
                        Text("글귀 추가하기")
                            .asfullCapsuleButton(background: .accent)
                    }
                    
                }
                
                Divider()
                    .padding(.vertical)
                
                BiblioInfoView(item)
                
                editBiblioInfo(isCustom: item.isCustomBook)
                
                Spacer()
            }
            .padding()
        }
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                NavigationLink {
                    EditBookView(viewModel: EditBookViewModel(repository: MyBookRepository()), isEditted: $isEditted, book: item)
                } label: {
                    Image(ImageName.edit)
                        .resizable()
                        .frame(width: 24, height: 24)
                }
                
                ImageWrapper(name: ImageName.trash)
                    .frame(width: 24, height: 24)
                    .wrapToButton {
                        showAlert = true
                    }
                    .alert("정말 삭제 하시겠습니까? \n책 삭제시 책의 메모도 모두 삭제됩니다:)", isPresented: $showAlert) {
                        Button("삭제") {
                            viewModel.action(.deleteButtonTap)
                            NotificationPublisher.shared.send("\(item.id)")
                            cancellables.removeAll()
                            dismiss()
                        }
                        Button("취소", role: .cancel) {}
                    }
            }
        }
        .navigationTitle("도서 상세 정보")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear{
            viewModel.action(.viewOnAppear(item: (item, isEditted)))
            NotificationPublisher.shared.publisher
                .sink { id in
                    if id == "\(item.id)" {
                        cancellables.removeAll()
                        dismiss()
                    }
                }
                .store(in: &cancellables)
        }
        .onDisappear {
            if !presentationMode.wrappedValue.isPresented {
                cancellables.removeAll()
            }
        }
    }
    
    func BiblioInfoView(_ item: MyBookModel) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            BiblioRowView(title: "작가", content: item.author)
            BiblioRowView(title: "출판사", content: item.publisher)
            BiblioRowView(title: "출판일", content: item.pubDate)
            BiblioRowView(title: "페이지수", content: "\(item.page)")
            BiblioRowView(title: "설명글", content: item.explanation)
        }
        .font(.body)
    }
    
    func editBiblioInfo(isCustom: Bool) -> some View {
        VStack {
            if isCustom {
                NavigationLink {
                    let bookInput = BookRegInputModel(title: item.title, author: item.author, isbn13: item.isbn13, cover: item.cover, publisher: item.publisher, pubDate: item.pubDate, page: String(item.page), explain: item.explanation)
                    let reivewInput = ReviewRegInputModel(startDate: item.startDate, endDate: item.endDate, readingState: item.status, rating: item.rate)
                    
                    NavigationLazyView(RegisterBookView(viewModel: RegisterBookViewModel(repository: MyBookRepository(), bookId: "\(item.id)", book: bookInput, review: reivewInput) { (newItem, cover) in
                        item = newItem
                        bookCover = cover
                    }))
                } label: {
                    Text("도서정보 수정하기")
                        .underline()
                        .foregroundStyle(.accent)
                }
                .padding()
            }
        }
    }
}

struct BookCoverInfoView: View {
    let bookId: String?
    let coverUrl: String
    let title: String
    let ogTitle: String
    let bookCover: UIImage?
    let coverSize = CGSize(width: 170, height: 209.1)
    
    var body: some View {
        VStack {
            if let bookCover {
                BookCover(content: Image(uiImage: bookCover).resizable().scaledToFill(), size: coverSize)
                
            } else if let bookId, let fileUrl = PhotoFileManager.shared.loadFileURL(filename: bookId) {
                BookCover(content: AsyncImageWrapper(url: fileUrl), size: coverSize)
                
            } else {
                BookCover(content: AsyncImageWrapper(url: URL(string: coverUrl)), size: coverSize)
            }
            
            Text(title)
                .frame(maxWidth: .infinity)
                .bold()
                .font(.system(size: 21))
                .multilineTextAlignment(.center)
                .padding(.top, 20)
            
            Text(ogTitle)
                .bold()
                .font(.system(size: 17))
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
        }
    }
}

struct ReadingStatusView: View {
    var item: MyBookModel
    
    var body: some View {
        VStack(spacing: 8) {
            ImageWrapper(name: item.status.imageName)
                .frame(width: 100, height: 23.3)
            
            RratingHeartUneditableView(rating: item.rate, isEditable: false)
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
    }
}

struct BiblioRowView: View {
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
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}



extension Notification.Name {
    static let BookDetailViewDeleted = Notification.Name("BookDetailViewDeleted")
}
