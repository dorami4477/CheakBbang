//
//  EditBookView.swift
//  CheakBbang
//
//  Created by 박다현 on 9/19/24.
//

import SwiftUI

struct EditBookView: View {
    @StateObject var viewModel: EditBookViewModel
    @Environment(\.dismiss) private var dismiss
    @Binding var isEditted: Bool
    
    var book: MyBookModel
    
    var body: some View {
        VStack {
            Text(book.title)
                .multilineTextAlignment(.center)
                .bold()
                .font(.system(size: 21))
                .padding(.bottom, 10)
            
            Text(book.originalTitle)
                .multilineTextAlignment(.center)
                .font(.system(size: 17))
            
            Divider()
                .padding(.vertical)
            
            Text("상태")
                .foregroundStyle(.gray)
                .font(.system(size: 14))
            HStack {
                radioSectionGroup(sectionTitle: "readingState", selectedItem: $viewModel.input.readingState, selectedColor: .accent) { index, state in
                    viewModel.input.readingState = state
                }
            }
            
            Divider()
                .padding(.vertical)
            
            Text("내 평점")
                .foregroundStyle(.gray)
                .font(.system(size: 14))
            RatingHeartView(rating: $viewModel.input.rating)
            
            Divider()
                .padding(.vertical)
            
            if viewModel.input.readingState == .finished || viewModel.input.readingState == .ongoing {
                Text("독서 시작일")
                    .foregroundStyle(.gray)
                    .font(.system(size: 14))
                DatePicker(selection: $viewModel.input.startDate, displayedComponents: .date) {}
                    .labelsHidden()
                    .padding(.bottom, 10)
            }

            
            if viewModel.input.readingState == .finished {
                Text("독서 종료일")
                    .foregroundStyle(.gray)
                    .font(.system(size: 14))
                DatePicker(selection: $viewModel.input.endDate, in: viewModel.input.startDate..., displayedComponents: .date) {}
                    .labelsHidden()
            }
            
            Spacer()
            
            Text("저장")
                .asfullCapsuleButton(background: .accent)
                .wrapToButton {
                    viewModel.action(.addButtonTap(item: book))
                    isEditted = true
                    dismiss()
                }

        }
        .padding()
        .onAppear{
            viewModel.action(.viewOnTask(item: book))
        }
    }
}
