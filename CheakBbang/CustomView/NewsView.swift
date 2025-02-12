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
        VStack {
            AsyncImageWrapper(url: URL(string: urlString), contentMode: .fit)
                .frame(width: 169)
            Text("\(urlString)")
            
            HStack {
                Image(systemName: isChecked ? "checkmark.square" : "square")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.blue)
                    .onTapGesture {
                        isChecked.toggle()
                        UserDefaultsManager.hasSeenPopup = isChecked
                        UserDefaultsManager.newsNum = newNums
                    }
                
                Text("더이상 안보기")
                
                Button(action: {
                    withAnimation {
                        showPopup = false
                    }
                }) {
                    Text("확인")
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
}
