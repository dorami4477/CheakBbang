//
//  NewsView.swift
//  CheakBbang
//
//  Created by 박다현 on 2/12/25.
//

import SwiftUI

struct NewsView: View {
    @Binding var showPopup: Bool
    @State private var isChecked = false
    
    var newNums: Int
    var urlString: String
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                AsyncImageWrapper(url: URL(string: urlString), contentMode: .fit)
                
                HStack {
                    HStack {
                        Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                        
                        Text("더이상 안보기")
                    }
                    .onTapGesture {
                        isChecked.toggle()
                        UserDefaultsManager.hasSeenPopup = isChecked
                        UserDefaultsManager.newsNum = newNums
                    }
                    
                    Divider()
                        .frame(width: 2, height: 20)
                        .background(Color.black)
                        .padding(.horizontal, 16)
                    
                    Button(action: {
                        withAnimation {
                            showPopup = false
                        }
                    }) {
                        Text("확인")
                            .foregroundStyle(.black)
                    }
                }
                .padding(.top, 12)
                
                
            }
            .padding(20)
            .frame(width: 300)
            .background(Color.white)
            .cornerRadius(16)
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.black, lineWidth: 3))
            .shadow(radius: 10)
        }
    }
}
