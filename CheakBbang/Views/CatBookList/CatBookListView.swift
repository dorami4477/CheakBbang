//
//  CatBookListView.swift
//  CheakBbang
//
//  Created by 박다현 on 9/10/24.
//

import SwiftUI
import RealmSwift

struct CatBookListView: View {
    @StateObject var viewModel: CatBookListViewModel
    @State private var showBubble = false
    @State private var txtBubble: TextBubble = .phrase1
    @State private var timer: DispatchWorkItem? = nil
    @State private var shouldUpdate = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack{
                Image(ImageName.background)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                VStack(spacing: 5) {
                    ZStack {
                        VStack{
                            ScrollView(.vertical) {
                                let itemHeight = geometry.size.width * 0.86 + viewModel.output.itemHeight
                                let space = (geometry.size.height - itemHeight)
                                let level = CGFloat(UserDefaultsManager.level - 1)

                                if 0 < space &&  70 < space {
                                    Spacer(minLength: space)
                                } else {
                                    Spacer(minLength: 70)
                                }
                                
                                bookListView()
                                    .padding(.top,  -(level * 80))
                                
                                Image(ImageName.bottom)
                                    .resizable()
                                    .frame(width: geometry.size.width, height: geometry.size.width * 0.86)
                            }
                        }
                        VStack{
                            InfoView(txtBubble: $txtBubble, showBubble: $showBubble,
                                     bookCount: $viewModel.output.bookCount, totalPage: $viewModel.output.totalPage)
                            .padding(.top)
                            Spacer()
                        }
                        VStack{
                            FloatingButton()
                        }
                    }
                }
            }
        }
        .alert("새로운 업데이트가 있어요! 앱을 업데이트 해주세요. \n감사합니다.", isPresented: $shouldUpdate) {
            Button("업데이트 하러가기") {
                openAppStore(appId: APIKeys.appID)
            }
        }
        .onAppear {
            viewModel.action(.viewOnAppear)
            AppVersionManager.shared.shouldUpdate { needUpdate in
                shouldUpdate = needUpdate
            }
        }
    }
    
    private func bookListView() -> some View {
        VStack {
            ForEach(Array(zip(viewModel.output.bookList.indices, viewModel.output.bookList)), id: \.1.id) { index, item in
                let alignment = viewModel.isLeadingAlignment(for: index) ? Alignment.leading : Alignment.trailing
                let padding = viewModel.isLeadingAlignment(for: index) ? Edge.Set.leading : Edge.Set.trailing
                let input = BookRowInput(item: item,
                                         align: alignment,
                                         padding: padding,
                                         isFirst: index % 5 == 0,
                                         isLast: viewModel.output.bookCount - 1 == index,
                                         isToy: index % 5 == 4,
                                         level: index / 5 + 1)

                bookRowView(input: input)
                    .offset(y: CGFloat((index / 5) * 80))
            }
            .scaleEffect(y: -1)
        }
        .scaleEffect(y: -1)
    }
    
    private func bookRowView(input: BookRowInput) -> some View {
        VStack{
            if input.isLast {
                GIFView(gifName: ImageName.cat01, width: 110)
                    .frame(width: 110, height: 73)
                    .clipped()
                    .zIndex(3)
                    .padding(.bottom, -20)
                    .onTapGesture {
                        withAnimation(.bouncy) {
                            showBubble = true
                            txtBubble = TextBubble.allCases.randomElement()!
                        }
                        timer?.cancel()
                        timer = DispatchWorkItem {
                            withAnimation {
                                showBubble = false
                            }
                        }
                        
                        if let timer = timer {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: timer)
                        }
                    }
            }
            
            if input.isToy && !input.isLast {
                if let itemImage = PhotoFileManager.shared.loadFileImage(filename: "toy_\(input.level)") {
                    Image(uiImage: itemImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 169)
                        .zIndex(3)
                        .padding(.bottom, -20)
                } else {
                    AsyncImageWrapper(url: URL(string: "\(APIKeys.itemBaseUrl)/toy_\(input.level).png"), contentMode: .fit)
                        .frame(width: 169)
                        .zIndex(3)
                        .padding(.bottom, -20)
                }
            }
            
            NavigationLink {
                NavigationLazyView(BookDetailView(viewModel: BookDetailViewModel(repository: MyBookRepository()), item: input.item))
            } label: {
                VStack {
                    ZStack {
                        Image(viewModel.bookImage(input.item.page))
                            .resizable()
                        Text(input.item.title.truncate(length: 11))
                            .bold()
                            .font(.caption)
                            .foregroundStyle(.white)
                            .transformEffect(CGAffineTransform(1.0, 0.069, 0, 1, 0, 0))
                            .padding(.leading, 6)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(width: 161, height: viewModel.bookImageHeight(input.item.page))
                    .padding(.bottom, input.isFirst ? -15 : 0)
                    .zIndex(2)
                    
                    if input.isFirst {
                        Image(ImageName.shelf)
                            .resizable()
                            .frame(width: 169, height: 31.5)
                            .zIndex(1)
                            
                    }
                }
            }

        }
        .padding(input.padding, 53)
        .frame(width: 169)
        .frame(maxWidth: .infinity, alignment: input.align)
        .padding(.bottom, -20)
    }
    
    private func openAppStore(appId: String) {
        let url = "itms-apps://itunes.apple.com/app/" + appId
        if let url = URL(string: url), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}
