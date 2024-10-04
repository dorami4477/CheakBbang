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
            ZStack {
                Image("image_door_catBG")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 0.78)
                GIFView(gifName: ImageName.cat01, width: UIScreen.main.bounds.width * 0.4)
                    .frame(width: UIScreen.main.bounds.width * 0.42, height: UIScreen.main.bounds.width * 0.29)
                    .padding(.top, -25)
            }
            .padding(.bottom, 40)
            
            Text("책빵과 함께 당신의 독서를 기록하세요!")
                .fontWeight(.heavy)
            
            TextField("닉네임을 적어주세요!", text: $nickName)
                .autocorrectionDisabled(true)
                .foregroundColor(Color.black)
                .focused($focus, equals: true)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.black, lineWidth: 4)
                        )
                )
                .padding(.vertical)
            
                Text("시작하기")
                .asfullCapsuleButton(background: nickName.isEmpty ? .gray.opacity(0.7) : .accent)
                .wrapToButton {
                    viewModel.saveNickname(nickName)
                    viewModel.isFirstRun = false
                }
                .disabled(nickName.isEmpty ? true : false)
        }
        .padding()
        .onTapGesture(perform: {
            UIApplication.shared.endEditing()
        })
    }
}

