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
    @State private var isSaved = false
    
    var body: some View {
        VStack {
            Text(viewModel.output.bookItem.title)
                .multilineTextAlignment(.center)
                .bold()
                .font(.system(size: 21))
                .padding(.bottom, 10)
            
            Text(viewModel.output.bookItem.subInfo.originalTitle ?? "")
                .multilineTextAlignment(.center)
                .font(.system(size: 17))
            
            Divider()
                .padding(.vertical)
            
            Text("상태")
                .foregroundStyle(.gray)
                .font(.system(size: 14))
            HStack {
                radioSectionGroup(sectionTitle: "readingState", selectedItem: .finished, selectedColor: .accent) { index, state in
                    viewModel.input.readingState = state
                }
            }
            
            Divider()
                .padding(.vertical)
            
            Text(viewModel.input.readingState == .upcoming ? "내 기대" : "내 평점")
                .foregroundStyle(.gray)
                .font(.system(size: 14))
            RratingHeartView(rating: $viewModel.input.rating)
            
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
                DatePicker(selection: $viewModel.input.endDate, displayedComponents: .date) {}
                    .labelsHidden()   
            }
            
            Spacer()
            
            Text("추가")
                .asfullCapsuleButton()
                .wrapToButton {
                    viewModel.action(.addButtonTap)
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



