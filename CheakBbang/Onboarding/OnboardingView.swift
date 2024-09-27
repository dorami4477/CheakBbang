//
//  OnboardingView.swift
//  CheakBbang
//
//  Created by 박다현 on 9/27/24.
//

import SwiftUI

struct OnboardingView: View {
    @ObservedObject var viewModel: ContentViewModel
    
    @Environment(\.dismiss) private var dismiss
    @State var nickName: String = ""
    @FocusState var focus: Bool
    
    var body: some View {
        VStack{
            GIFView(gifName: ImageName.cat01, width: 220)
                .frame(width: 220, height: 146)
                .padding(.bottom, -32)
                .zIndex(2)
            Image("book_4_05")
                .resizable()
                .frame(width: 305.2, height: 103.6)
                .padding(.bottom)
            TextField("닉네임을 적어주세요!", text: $nickName)
                .autocorrectionDisabled(true)
                .foregroundColor(Color.black)
                .focused($focus, equals: true)
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.accentColor, lineWidth: 4)
                        )
                )
                
                Text("시작하기")
                .asfullCapsuleButton(background: nickName.isEmpty ? .gray : .accent)
                .wrapToButton {
                    viewModel.saveNickname(nickName)
                    viewModel.isFirstRun = false
                }
                .disabled(nickName.isEmpty ? true : false)
        }
        .padding()
    }
}

