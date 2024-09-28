//
//  EditNicknameView.swift
//  CheakBbang
//
//  Created by 박다현 on 9/28/24.
//

import SwiftUI

struct EditNicknameView: View {
    @Binding var isPresented: Bool
    @State var nickName: String = UserDefaultsManager.nickName
    @FocusState var focus: Bool
    
    var body: some View {
        VStack {
            Text("닉네임 수정")
                .bold()
            TextField("고양이 이름을 지어주세요!", text: $nickName)
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
            
            Text("저장하기")
                .asfullCapsuleButton(background: nickName.isEmpty ? .gray.opacity(0.7) : .accent)
                .wrapToButton {
                    UserDefaultsManager.nickName = nickName
                    isPresented = false
                }
                .disabled(nickName.isEmpty ? true : false)
        }
        .padding()
    }
}

