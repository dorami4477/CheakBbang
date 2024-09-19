//
//  AddBookView.swift
//  CheakBbang
//
//  Created by 박다현 on 9/11/24.
//

import SwiftUI


struct AddBookView: View {
   
    var isbn13: String
    @StateObject var viewModel: AddBookViewModel
    @State private var rank: String = ""
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var isSaved = false
    @State var rating = 3.0
    
    var body: some View {
        VStack {
            Text(viewModel.output.bookItem.title)
            Text(viewModel.output.bookItem.subInfo.originalTitle ?? "")
            Divider()
                .padding(.vertical)
            Text("상태")
            HStack {
                radioSectionGroup(sectionTitle: "readingState", selectedItem: "읽고 있는 책", selectedColor: .accent) { index, title in
                    print(index, title)
                }
            }
            Text("평점")
            RratingHeartView(rating: $rating)
            DatePicker("시작일", selection: $startDate)
            DatePicker("종료일", selection: $endDate)
            Text("추가")
                .wrapToButton {
                    let newItem = MyBook(itemId: viewModel.output.bookItem.itemID, 
                                         title: viewModel.output.bookItem.title,
                                         originalTitle: viewModel.output.bookItem.subInfo.originalTitle ?? "",
                                         author: viewModel.output.bookItem.author,
                                         publisher: viewModel.output.bookItem.publisher,
                                         pubDate: viewModel.output.bookItem.pubDate,
                                         explanation: viewModel.output.bookItem.description,
                                         cover: viewModel.output.bookItem.cover, 
                                         isbn13: viewModel.output.bookItem.isbn13,
                                         rate: rating,
                                         page: viewModel.output.bookItem.subInfo.itemPage ?? 0,
                                         status: .finished,
                                         startDate: startDate,
                                         endDate: endDate)
                    viewModel.action(.addButtonTap(item: newItem))
                    isSaved = true
                }

        }
        .padding()
        .task {
            viewModel.action(.viewOnTask(isbn: isbn13))
        }
        .fullScreenCover(isPresented: $isSaved, content: {
            AddBookAniView()
        })
    }
}


private struct radioButton: View {
    let title: String
    let imageName: String
    let isSelected: Bool
    let selectedColor: Color
    let action: (() -> Void)?
    
    var body: some View {
        Button {
            action?()
        } label: {
            VStack {
                Image(imageName)
                    .resizable()
                    .frame(width: 112.6, height: 23.3)
                Text(LocalizedStringKey(title))
                ZStack(alignment: .center) {
                    Circle()
                        .strokeBorder(lineWidth: 2.0)
                        .scaleEffect(isSelected ? 1 : 0.8)
                        .foregroundColor(.gray)
                        .opacity(isSelected ? 0.8 : 0.0)
                    Circle()
                        .strokeBorder(lineWidth: 2.0)
                        .scaleEffect(isSelected ? 0.8 : 1)
                        .foregroundColor(.gray)
                        .opacity(isSelected ? 0.0 : 0.8)
                    Circle()
                        .fill(selectedColor)
                        .scaleEffect(isSelected ? 0.65 : 0.001)
                        .opacity(isSelected ? 1 : 0)
                }
                .animation(.spring(), value: isSelected)
                .frame(width: 23, height: 23)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

private struct radioSectionGroup: View {
    
    let sectionTitle: String
    @State var selectedItem: String = ""
    let selectedColor: Color
    let action: ((Int, String) -> Void)?
    
    var body: some View {
            getContent()
    }
    
    private func getContent() -> some View {
        ForEach(Array(ReadingState.allCases.enumerated()), id: \.offset) { index, item in
            radioButton(title: item.rawValue, imageName: item.imageName, isSelected: selectedItem == item.rawValue, selectedColor: selectedColor) {
                self.selectedItem = item.rawValue
                action?(index, selectedItem)
                vibration()
            }
        }
    }
    
    func vibration() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
}
