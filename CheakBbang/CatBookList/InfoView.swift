//
//  InfoView.swift
//  CheakBbang
//
//  Created by 박다현 on 10/15/24.
//

import SwiftUI

struct InfoView: View {
    @Binding var txtBubble: TextBubble
    @Binding var showBubble: Bool
    @Binding var bookCount: Int
    @Binding var totalPage: String
    
    var body: some View {
        HStack{
            VStack {
                Text("Books")
                    .font(.subheadline)
                Text("\(bookCount)")
                    .bold()
                    .font(.system(size: 17))
            }
            .padding(8)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.white).opacity(0.7)
            }
            
            Spacer()
            
            if showBubble {
                VStack {
                    Text(txtBubble.rawValue)
                        .font(.system(size: 15))
                        .lineLimit(2)
                        .bold()
                        .padding(10)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.black, lineWidth: 2)
                                )
                        )
                        .foregroundColor(.black)
                        .padding(.top, 15)
                    
                    Triangle()
                        .fill(Color.white)
                        .frame(width: 13, height: 10)
                        .rotationEffect(.degrees(180))
                        .padding(.top, -10)
                        .background {
                            Triangle()
                                .stroke(Color.black, lineWidth: 2)
                                .frame(width: 13, height: 10)
                                .rotationEffect(.degrees(180))
                                .padding(.top, -5)
                        }
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            showBubble = false
                        }
                    }
                }
            }
            
            Spacer()
            VStack {
                Text("Pages")
                    .font(.subheadline)
                Text("\(totalPage)")
                    .bold()
                    .font(.system(size: 17))
            }
            .padding(8)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.white).opacity(0.7)
            }
        }
        .padding(.horizontal, 30)
        .frame(maxWidth: .infinity)
        .frame(height: 30)
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}
