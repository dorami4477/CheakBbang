//
//  EditBookView.swift
//  CheakBbang
//
//  Created by 박다현 on 9/19/24.
//

import SwiftUI

struct EditBookView: View {
    var book: MyBook
    @StateObject var viewModel: EditBookViewModel
    
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
                radioSectionGroup(sectionTitle: "readingState", selectedItem: book.status, selectedColor: .accent) { index, state in
                    viewModel.input.readingState = state
                }
            }
            
            Divider()
                .padding(.vertical)
            
            Text("내 평점")
                .foregroundStyle(.gray)
                .font(.system(size: 14))
            RratingHeartView(rating: $viewModel.input.rating)
            
            Divider()
                .padding(.vertical)
            
            Text("독서 시작일")
                .foregroundStyle(.gray)
                .font(.system(size: 14))
            DatePicker(selection: $viewModel.input.startDate, displayedComponents: .date) {}
                .labelsHidden()
                .padding(.bottom, 10)
            
            Text("독서 종료일")
                .foregroundStyle(.gray)
                .font(.system(size: 14))
            DatePicker(selection: $viewModel.input.endDate, displayedComponents: .date) {}
                .labelsHidden()
            
            Spacer()
            
            Text("저장")
                .wrapToButton {
                    viewModel.action(.addButtonTap(item: book))
                }

        }
        .padding()
        .onAppear{
            viewModel.action(.viewOnTask(item: book))
        }
    }
}
