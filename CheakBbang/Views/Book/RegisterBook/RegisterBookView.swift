//
//  RegisterBookView.swift
//  CheakBbang
//
//  Created by 박다현 on 12/21/24.
//

import SwiftUI
import Combine
import PhotosUI

struct RegisterBookView: View {
    @StateObject var viewModel: RegisterBookViewModel
    @State var cancellables = Set<AnyCancellable>()
    @State private var isCustomCameraViewPresented: Bool = false
    @State private var bookCover: UIImage? = nil
    @State private var selectedItem: PhotosPickerItem?
    @State private var book: BookRegInputModel = BookRegInputModel()
    @State private var review: ReviewRegInputModel = ReviewRegInputModel()

    @State private var isBookInfoExpanded = false
    @State private var isMyReviewExpanded = false
    @State private var isFormValid = false
    
    var body: some View {
        Group {
            ScrollView {
                bookCoverSection()
                
                SectionWrap(title: "책정보", content: bookInfoRow(book: $book, onValidityChange: { isValid in
                    isFormValid = isValid
                }), isExpanded: $isBookInfoExpanded, isValid: isFormValid)
                
                SectionWrap(title: "책리뷰", content: MyReviewRow(review: $review), isExpanded: $isMyReviewExpanded, isValid: true)
                
            }
            
            Text("추가")
                .asfullCapsuleButton(background: .accent)
                .wrapToButton {
                }
        }
        .padding()
    }
    
    func bookCoverSection() -> some View {
        HStack {
            Text("책커버")
            
        Spacer()
            
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
                        if let imageData = try await newItem.loadTransferable(type: Data.self) {
                            bookCover = UIImage(data: imageData)!.cropToAspectRatio(aspectRatio: 1.0/1.5)
                        }
                    } catch {
                        print("Error loading image: \(error)")
                    }
                }
            }
        }
    }
}

struct SectionWrap<Content: View>: View {
    var title: String
    var content: Content
    var isExpanded: Binding<Bool>
    var isValid: Bool
    
    var body: some View {
        VStack {
            Button(action: {
                withAnimation {
                    isExpanded.wrappedValue.toggle()
                }
            }, label: {
                HStack {
                    Text(title)
                        .foregroundStyle(.black)
                    
                    Spacer()
                    
                    if isValid {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    }
                    
                    (isExpanded.wrappedValue ? Image(systemName: "chevron.up") : Image(systemName: "chevron.down"))
                }
            })
            
            if isExpanded.wrappedValue {
                content
            }
        }
        .padding(.vertical)
    }
}

struct bookInfoRow: View {
    @Binding var book: BookRegInputModel
    @State private var isValid = false
    
    var onValidityChange: (Bool) -> Void
    
    var body: some View {
        VStack {
            HStack {
                Text("제목")
                    .frame(width: 75, alignment: .leading)
                
                TextField("제목을 입력하세요.*", text: $book.title)
                    .textFieldStyle(.roundedBorder)
            }
            HStack {
                Text("작가")
                    .frame(width: 75, alignment: .leading)
                
                TextField("작가를 입력하세요.", text: $book.author)
                    .textFieldStyle(.roundedBorder)
            }
            
            HStack {
                Text("출판사")
                    .frame(width: 75, alignment: .leading)
                
                TextField("출판사를 입력하세요.", text: $book.publisher)
                    .textFieldStyle(.roundedBorder)
            }
            
            HStack {
                Text("페이지수")
                    .frame(width: 75, alignment: .leading)
                
                TextField("페이지수를 입력하세요.*", text: $book.page)
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)
            }
            
            HStack {
                Text("ISBN")
                    .frame(width: 75, alignment: .leading)
                
                TextField("ISBN을 입력하세요.", text: $book.isbn13)
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)
            }
        }
        .onChange(of: book.title) { _ in
            checkFormValidity()
        }
        .onChange(of: book.page) { _ in
            checkFormValidity()
        }
    }
    
    func checkFormValidity() {
        let isValid = !book.title.isEmpty && !book.page.isEmpty
        self.isValid = isValid
        onValidityChange(isValid)
    }
}

struct MyReviewRow: View {
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
