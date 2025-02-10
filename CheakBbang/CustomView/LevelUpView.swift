//
//  LevelUpView.swift
//  CheakBbang
//
//  Created by 박다현 on 2/10/25.
//

import SwiftUI

struct LevelUpView: View {
    @Binding var showLevelUp: Bool
    
    var body: some View {
        VStack {
            AsyncImageWrapper(url: URL(string: "\(APIKeys.itemBaseUrl)/toy_\(UserDefaultsManager.level - 1).png"), contentMode: .fit)
                .frame(width: 169)
            Text("Level Up! 새로운 장난감을 획득하셨습니다!")
            Text("Level \(UserDefaultsManager.level)")
            
            Button(action: {
                withAnimation {
                    showLevelUp = false
                }
            }) {
                Text("Close")
                    .foregroundColor(.red)
                    .padding(8)
                    .background(Color.white)
                    .cornerRadius(5)
                    .shadow(radius: 5)
            }
            .padding(.top, 10)
        }
    }
}
