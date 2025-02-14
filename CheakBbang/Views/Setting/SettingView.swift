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
    @State private var nickName: String = UserDefaultsManager.nickName
    @State private var toast: Toast? = nil
    
    var body: some View {
        ScrollView {
            VStack {
                ImageWrapper(name: ImageName.configBG, contentMode: .fill)
                    .overlay {
                        VStack {
                            Text(viewModel.output.memoPharse)
                                .font(.custom("BinggraeII", size: 16))
                                .multilineTextAlignment(.center)
                                .lineLimit(3)
                                .frame(maxWidth: UIScreen.main.bounds.width * 0.60)
                                .frame(height: 100, alignment: .center)
                                .padding(.top, 4)
                            GIFView(gifName: ImageName.cat01, width: UIScreen.main.bounds.width * 0.57)
                                .frame(width: UIScreen.main.bounds.width * 0.57)
                                .padding(.bottom, -13)
                        }
                    }
                    .padding(.vertical, 25)
                
                HStack {
                    Text(nickName)
                        .bold()
                        .font(.system(size: 25))
                    
                    ImageWrapper(name: ImageName.configEdit)
                        .frame(width: 25, height: 24)
                        .wrapToButton {
                            showEditName.toggle()
                        }
                }
                HStack {
                    recordList(image: ImageName.configNum01, title: "읽은 페이지", data: "\(viewModel.output.totalPage)")
                    Divider()
                        .padding(.horizontal)
                    recordList(image: ImageName.configNum02, title: "읽은 책", data: "\(viewModel.output.bookCount)")
                    Divider()
                        .padding(.horizontal)
                    recordList(image: ImageName.configNum03, title: "모든 글귀", data: "\(viewModel.output.MemoCount)")
                    Divider()
                        .padding(.horizontal)
                    recordList(image: ImageName.configNum03, title: "레벨", data: "\(UserDefaultsManager.level)")
                }
                
                //let level = UserDefaultsManager.level
                let level = 3

                VStack {
                    Divider()
                        .padding(.vertical, 10)
                    
                    HStack(spacing: 10) {
                        Text("냥이 장난감")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(.gray)
                        
                        Image("question")
                            .resizable()
                            .frame(width: 10, height: 10)
                            .onTapGesture {
                                toast = Toast(style: .info, message: "레벨에 따라 장난감을 획득할 수 있습니다!")
                            }
                        
                        Spacer()
                    }
                    
                    ForEach(0...(level / 3), id: \.self) { row in
                        HStack {
                            ForEach(0..<3, id: \.self) { column in
                                let index = (row * 3) + column
                                if index < level {
                                    VStack {
                                        if let itemImage = PhotoFileManager.shared.loadFileImage(filename: "toy_\(index + 1)") {
                                            Image(uiImage: itemImage)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: UIScreen.main.bounds.width * 0.3, height: UIScreen.main.bounds.width * 0.2)
                                                .zIndex(3)
                                                .padding(.bottom, -20)
                                        } else {
                                            AsyncImageWrapper(url: URL(string: "\(APIKeys.itemBaseUrl)/toy_\(index + 1).png"), contentMode: .fit)
                                                .frame(width: UIScreen.main.bounds.width * 0.3)
                                                .zIndex(3)
                                                .padding(.bottom, -20)
                                        }
                                        
                                        Text("Level \(index + 1)")
                    
                                    }
                                    
                                } else if index == level {
                                    VStack {
                                        Image("icon_heart_01")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: UIScreen.main.bounds.width * 0.3, height: UIScreen.main.bounds.width * 0.2)
                                        
                                        Text("Level \(level + 1)")
                                            .foregroundStyle(.gray)
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }

                VStack {
                    Divider()
                        .padding(.vertical, 10)
                    
                    HStack {
                        Link(destination: URL(string: "https://forms.gle/iz1SvJXuc7tg9wPj9")!) {
                            ImageWrapper(name: ImageName.configMail)
                                .frame(width: 20)
                            Text("의견 전달하기")
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
                        Text("Copyright 2024. \nDahyun Park All rights reserved.")
                            .font(.system(size: 13))
                            .foregroundStyle(.gray)
                            .multilineTextAlignment(.trailing)
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
                            .font(.system(size: 13))
                            .foregroundStyle(.gray)
                        
                    }
                }
            }
            .padding()
        }
        .sheet(isPresented: $showEditName) {
            EditNicknameView(isPresented: $showEditName, nickName: $nickName)
                .presentationDetents([.fraction(0.3)])
        }
        .navigationTitle("마이페이지")
        .navigationBarTitleDisplayMode(.inline)
        .toastView(toast: $toast)
        .onAppear {
            viewModel.action(.viewOnAppear)
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
