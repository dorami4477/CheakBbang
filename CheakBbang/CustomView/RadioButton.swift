//
//  RadioButton.swift
//  CheakBbang
//
//  Created by 박다현 on 9/19/24.
//

import SwiftUI

struct radioButton: View {
    let title: String
    let explan: String
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
                    .bold()
                    .font(.system(size: 15))
                    .padding(.bottom, 1)
                Text(explan)
                    .font(.system(size: 13))
                    .foregroundStyle(.gray)
                
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

struct radioSectionGroup: View {
    
    let sectionTitle: String
    @State var selectedItem: ReadingState = .finished
    let selectedColor: Color
    let action: ((Int, ReadingState) -> Void)?
    
    var body: some View {
            getContent()
    }
    
    private func getContent() -> some View {
        ForEach(Array(ReadingState.allCases.enumerated()), id: \.offset) { index, item in
            radioButton(title: item.rawValue, explan: item.explanation, imageName: item.imageName, isSelected: selectedItem == item, selectedColor: selectedColor) {
                self.selectedItem = item
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
