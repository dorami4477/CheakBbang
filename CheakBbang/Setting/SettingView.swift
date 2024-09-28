//
//  SettingView.swift
//  CheakBbang
//
//  Created by 박다현 on 9/28/24.
//

import SwiftUI
import RealmSwift

struct SettingView: View {
    @StateObject var viewModel: SettingViewModel
    @State private var showEditName: Bool = false
    
    var body: some View {
        VStack {
            ImageWrapper(name: ImageName.configBG, contentMode: .fill)
                .overlay {
                    VStack {
                        Text("텍스트가 있어야 하네")
                            .font(.custom("BinggraeII", size: 16))
                            .multilineTextAlignment(.center)
                            .lineLimit(3)
                            .frame(maxWidth: UIScreen.main.bounds.width * 0.70)
                            .frame(height: 100, alignment: .center)
                            .padding(.top, 4)
                        GIFView(gifName: ImageName.cat01, width: UIScreen.main.bounds.width * 0.57)
                            .frame(width: UIScreen.main.bounds.width * 0.57)
                            .padding(.bottom, -13)
                    }
                }
                .padding(.vertical, 30)
            
            HStack {
                Text(viewModel.output.nickName)
                    .bold()
                    .font(.system(size: 25))
                
                ImageWrapper(name: ImageName.configEdit)
                    .frame(width: 25, height: 24)
                    .wrapToButton {
                        showEditName.toggle()
                    }
            }
            HStack {
                recordList(image: ImageName.configNum01, title: "읽은 페이지 수", data: "\(viewModel.output.totalPage)")
                Divider()
                    .padding(.horizontal)
                recordList(image: ImageName.configNum02, title: "읽은 책 수", data: "\(viewModel.output.bookCount)")
                Divider()
                    .padding(.horizontal)
                recordList(image: ImageName.configNum03, title: "모든 글귀 수", data: "\(viewModel.output.MemoCount)")
            }
            
            VStack {
                Divider()
                    .padding(.vertical, 10)
                
                HStack {
                    NavigationLink {
                        
                    } label: {
                        ImageWrapper(name: ImageName.configMail)
                            .frame(width: 20)
                        Text("문의하기")
                            .foregroundStyle(.gray)
                        Spacer()
                    }
                }
                Divider()
                    .padding(.vertical, 10)
                
                HStack {
                    ImageWrapper(name: ImageName.configMember)
                        .frame(width: 20)
                    Text("만든이")
                        .foregroundStyle(.gray)
                    Spacer()
                }
                Divider()
                    .padding(.vertical, 10)
                
                HStack {
                    ImageWrapper(name: ImageName.configAppver)
                        .frame(width: 20)
                    Text("앱버전")
                        .foregroundStyle(.gray)
                    Spacer()
                    Text("\(viewModel.output.version)")
                    
                }
            }
        }
        .padding()
        .sheet(isPresented: $showEditName) {
            EditNicknameView(isPresented: $showEditName)
                .presentationDetents([.fraction(0.3)])
        }
        
    }

    func recordList(image: String, title: String, data: String) -> some View {
        VStack {
            ImageWrapper(name: image)
                .frame(width: 30)
            Text(title)
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(.gray)
            Text(data)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(.accent)
                .padding(.top, 10)
        }
    }
}
