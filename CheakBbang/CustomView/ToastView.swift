//
//  ToastView.swift
//  CheakBbang
//
//  Created by 박다현 on 9/29/24.
//

import SwiftUI

struct ToastView: View {
  var style: ToastStyle
  var message: String
  var width = CGFloat.infinity
  var onCancelTapped: (() -> Void)
  
  var body: some View {
    HStack(alignment: .center, spacing: 12) {
      Image(systemName: style.iconFileName)
        .foregroundColor(style.themeColor)
      Text(message)
        .font(.system(size: 15))
        .foregroundStyle(style.themeColor)
      
      Spacer(minLength: 10)
      
      Button {
        onCancelTapped()
      } label: {
        Image(systemName: "xmark")
          .foregroundColor(style.themeColor)
      }
    }
    .padding()
    .frame(minWidth: 0, maxWidth: width)
    .background(.white)
    .cornerRadius(8)
    .background {
        RoundedRectangle(cornerRadius: 8)
            .stroke(lineWidth: 3)
            .foregroundStyle(style.themeColor)
            .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 2)
    }
    .padding(.horizontal, 16)
  }
}
