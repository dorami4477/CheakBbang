//
//  AddBookView.swift
//  CheakBbang
//
//  Created by 박다현 on 9/11/24.
//

import SwiftUI

struct AddBookView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: AddBookViewModel
    //@EnvironmentObject var appState: AppState
    //@State private var isSaved = false
    var item: ItemDTO
    @Binding var addNew: Bool
    
    
    var body: some View {
        VStack {
            titleSection(item: viewModel.output.bookItem)
            
            Divider()
                .padding(.vertical)
            
            stateSection()
            
            Divider()
                .padding(.vertical)
            
            ratingSection()
            
            Divider()
                .padding(.vertical)
            
            dateSection()
            
            Spacer()
            
            Text("추가")
                .asfullCapsuleButton(background: .accent)
                .wrapToButton {
                    viewModel.action(.addButtonTap)
                    UserDefaultsManager.bookCount += 1
                    UserDefaultsManager.level = UserDefaultsManager.bookCount % 5 > 0 ? UserDefaultsManager.bookCount / 5 + 1 : UserDefaultsManager.bookCount / 5
                    addNew = true
                    dismiss()
                }

        }
        .padding()
        .task {
            viewModel.action(.viewOnTask(item: item))
        }

    }
    
    func titleSection(item: ItemDTO) -> some View {
        VStack {
            Text(item.title)
                .multilineTextAlignment(.center)
                .bold()
                .font(.system(size: 21))
                .padding(.bottom, 10)
            
            Text(item.subInfo.originalTitle ?? "")
                .multilineTextAlignment(.center)
                .font(.system(size: 17))
        }
    }
    
    func stateSection() -> some View {
        VStack {
            Text("상태")
                .foregroundStyle(.gray)
                .font(.system(size: 14))
            
            HStack {
                radioSectionGroup(sectionTitle: "readingState", selectedItem: $viewModel.input.readingState, selectedColor: .accent) { index, state in
                    viewModel.input.readingState = state
                }
            }
        }
    }
    
    func ratingSection() -> some View {
        VStack {
            Text(viewModel.input.readingState == .upcoming ? "내 기대" : "내 평점")
                .foregroundStyle(.gray)
                .font(.system(size: 14))
            
            RatingHeartView(rating: $viewModel.input.rating)
        }
    }
    
    func dateSection() -> some View {
        VStack {
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
        }
    }
}



