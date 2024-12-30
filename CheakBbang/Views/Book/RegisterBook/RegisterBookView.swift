//
//  RegisterBookView.swift
//  CheakBbang
//
//  Created by 박다현 on 12/21/24.
//

import SwiftUI
import PhotosUI

struct RegisterBookView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: RegisterBookViewModel

    @State private var bookCover: UIImage? = nil
    @State private var isFormValid = false
    @State private var isReivewValid = true
    @State private var toast: Toast? = nil
    
    var body: some View {
        VStack {
            ScrollView {
                SectionWrap(title: "도서등록", content: bookInfoSection(book: $viewModel.output.book, bookCover: $bookCover, onValidityChange: { isValid in
                    isFormValid = isValid
                }), isValid: isFormValid)
                
                if viewModel.output.bookId == nil {
                    Divider()
                        .padding(.vertical)
                    
                    SectionWrap(title: "리뷰", content: MyReviewSection(review: $viewModel.output.review), isValid: isReivewValid)
                }
            }
            .scrollIndicators(.hidden)
            
            Text("저장")
                .asfullCapsuleButton(background: isFormValid && isReivewValid ? .accent : .gray)
                .wrapToButton {
                    if isFormValid && isReivewValid, let bookCover {
                        viewModel.action(.createBook(book: viewModel.output.book, review: viewModel.output.review, cover: bookCover))
                        dismiss()
                        
                    } else {
                        toast = Toast(style: .info, message: "필수 정보를 입력해주세요. :)")
                    }
                }
        }
        .padding()
        .toastView(toast: $toast)
        .onTapGesture(perform: {
            UIApplication.shared.endEditing()
        })
        .onAppear {
            if !viewModel.output.book.cover.isEmpty, let image = PhotoFileManager.shared.loadFileImage(filename: viewModel.output.book.cover) {
                bookCover = image
            }
        }
    }
}

struct SectionWrap<Content: View>: View {
    var title: String
    var content: Content
    var isValid: Bool
    
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .foregroundStyle(.black)
                    .asFontWrapper(size: 22, weight: .bold)
                
                if isValid {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.cyan)
                }
                
                Spacer()
                
            }
            content
        }
        .padding(.vertical)
    }
}

struct bookInfoSection: View {
    @Binding var book: BookRegInputModel
    @Binding var bookCover: UIImage?
    @State private var isValid = false
    @FocusState private var focusedField: Field?
    
    enum Field: Hashable {
        case title, author, publisher, pubDate, page, isbn, explain
    }
    
    var onValidityChange: (Bool) -> Void
    
    var body: some View {
        VStack {
            bookCoverRow(bookCover: $bookCover)
            bookInfoRow(title: "제목", keyboardType: .default, isRequired: true, content: $book.title)
                .focused($focusedField, equals: .title)
                .onSubmit {
                    focusedField = .author
                }
            
            bookInfoRow(title: "작가", keyboardType: .default, isRequired: true, content: $book.author)
                .focused($focusedField, equals: .author)
                .onSubmit {
                    focusedField = .publisher
                }
            
            bookInfoRow(title: "출판사", keyboardType: .default, content: $book.publisher)
                .focused($focusedField, equals: .publisher)
                .onSubmit {
                    focusedField = .pubDate
                }
            
            bookInfoRow(title: "출판일", keyboardType: .numbersAndPunctuation, content: $book.pubDate)
                .focused($focusedField, equals: .pubDate)
                .onSubmit {
                    focusedField = .page
                }
            
            bookInfoRow(title: "페이지수", keyboardType: .numberPad, isRequired: true, content: $book.page)
                .focused($focusedField, equals: .page)
                .onSubmit {
                    focusedField = .isbn
                }
            
            bookInfoRow(title: "ISBN13", keyboardType: .numberPad, content: $book.isbn13)
                .focused($focusedField, equals: .isbn)
                .onSubmit {
                    focusedField = .explain
                }
            
            bookInfoRow(title: "설명글", keyboardType: .default, content: $book.explain)
                .focused($focusedField, equals: .explain)
                .onSubmit {
                    focusedField = nil
                }
        }
        .onChange(of: bookCover) { _ in
            checkFormValidity()
        }
        .onChange(of: book.title) { _ in
            checkFormValidity()
        }        
        .onChange(of: book.author) { _ in
            checkFormValidity()
        }
        .onChange(of: book.page) { _ in
            checkFormValidity()
        }
    }
    
    func checkFormValidity() {
        let isValid = bookCover != nil && !book.title.isEmpty && !book.author.isEmpty && !book.page.isEmpty
        self.isValid = isValid
        onValidityChange(isValid)
    }
}

struct bookCoverRow: View {
    @State private var isCustomCameraViewPresented: Bool = false
    @Binding var bookCover: UIImage?
    @State private var selectedItem: PhotosPickerItem?
    
    var body: some View {
        HStack {
            HStack {
                Text("표지")
                    .fontWeight(.medium)
                    .foregroundStyle(.gray)
                
                Text("*")
                    .foregroundStyle(.accent)
            }
            .frame(maxWidth: 75, alignment: .topLeading)
            
            if let bookCover {
                Image(uiImage: bookCover)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 150)
                    .clipped()
                    .cornerRadius(10)
            }
            
            Button {
                isCustomCameraViewPresented.toggle()
            } label: {
                Image("icon_camera")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
            }
            .sheet(isPresented: $isCustomCameraViewPresented, content: {
                BookCameraView(capturedImage: $bookCover)
            })
            
            PhotosPicker(
                selection: $selectedItem,
                matching: .images
            ) {
                Image("icon_gallery")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
            }
            .onChange(of: selectedItem) { newItem in
                Task {
                    guard let newItem = newItem else { return }
                    do {
                        if let imageData = try await newItem.loadTransferable(type: Data.self), let uiImage = UIImage(data: imageData) {
                            bookCover = uiImage
                        }
                    } catch {
                        print("Error loading image: \(error)")
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct bookInfoRow: View {
    let title: String
    let keyboardType: UIKeyboardType
    var isRequired: Bool = false
    
    @Binding var content: String
    @FocusState var isFocused: Bool
    
    var body: some View {
        HStack {
            HStack {
                Text(title)
                    .fontWeight(.medium)
                    .foregroundStyle(.gray)
                
                if isRequired {
                    Text("*")
                        .foregroundStyle(.accent)
                }
            }
            .frame(maxWidth: 75, alignment: .topLeading)
            
            TextField("\(title)", text: $content)
                .keyboardType(keyboardType)
                .focused($isFocused)
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .background(Color.white)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
                .onSubmit {
                    isFocused = false
                }
        }
    }
}

struct MyReviewSection: View {
    @Binding var review: ReviewRegInputModel
    @State private var isValid = true
    
    var body: some View {
        VStack {
            stateSection()
            
            Divider()
                .padding(.vertical)
            
            ratingSection()
            
            Divider()
                .padding(.vertical)
            
            dateSection()
        }

    }
    
    func stateSection() -> some View {
        VStack {
            Text("상태")
                .foregroundStyle(.gray)
                .font(.system(size: 14))
            
            HStack {
                radioSectionGroup(sectionTitle: "readingState", selectedItem: $review.readingState, selectedColor: .accent) { index, state in
                    review.readingState = state
                }
            }
        }
    }
    
    func ratingSection() -> some View {
        VStack {
            Text(review.readingState == .upcoming ? "내 기대" : "내 평점")
                .foregroundStyle(.gray)
                .font(.system(size: 14))
            
            RratingHeartView(rating: $review.rating)
        }
    }
    
    func dateSection() -> some View {
        VStack {
            if review.readingState == .finished || review.readingState == .ongoing {
                Text("독서 시작일")
                    .foregroundStyle(.gray)
                    .font(.system(size: 14))
                DatePicker(selection: $review.startDate, displayedComponents: .date) {}
                    .labelsHidden()
                    .padding(.bottom, 10)
            }
            
            
            if review.readingState == .finished {
                Text("독서 종료일")
                    .foregroundStyle(.gray)
                    .font(.system(size: 14))
                DatePicker(selection: $review.endDate, in: review.startDate..., displayedComponents: .date) {}
                    .labelsHidden()
            }
        }
    }
}
