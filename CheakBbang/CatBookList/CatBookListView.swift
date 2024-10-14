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
                                if 0 < space {
                                    Spacer(minLength: space)
                                }
                                bookListView()
                                    .padding(.top, space < 70 ? 70 - (0 < space ? space : 0) : 0)
                                
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
                
                if viewModel.output.bookCount - 1 == index {
                    bookRowView(item: item, align: alignment, padding: padding, isFirst: index % 5 == 0, isLast: true)
                        .padding(.bottom, index != 0 && index % 5 == 0 ? -50 : 0)
                    
                } else {
                    bookRowView(item: item, align: alignment, padding: padding, isFirst: index % 5 == 0, isLast: false)
                        .padding(.bottom, index != 0 && index % 5 == 0 ? -50 : 0)
                }
                
            }
            .scaleEffect(y: -1)
        }
        .scaleEffect(y: -1)
    }
    
    private func bookRowView(item: MyBookDTO, align: Alignment, padding: Edge.Set, isFirst: Bool, isLast: Bool) -> some View {
        VStack{
            if isLast {
                GIFView(gifName: ImageName.cat01, width: 110)
                    .frame(width: 110, height: 73)
                    .clipped()
                    .zIndex(3)
                    .padding(.bottom, isLast ? -20 : 0)
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
            
            NavigationLink {
                NavigationLazyView(BookDetailView(viewModel: BookDetailViewModel(), item: item))
            } label: {
                ZStack {
                    Image(viewModel.bookImage(item.page))
                        .resizable()
                    Text(item.title.truncate(length: 11))
                        .bold()
                        .font(.caption)
                        .foregroundStyle(.white)
                        .transformEffect(CGAffineTransform(1.0, 0.069, 0, 1, 0, 0))
                        .padding(.leading, 6)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(width: 161, height: viewModel.bookImageHeight(item.page))
                .padding(.bottom, isFirst ? -15 : 0)
            }
            .zIndex(2)
            
            
            if isFirst {
                Image(ImageName.shelf)
                    .resizable()
                    .frame(width: 169, height: 31.5)
                    .zIndex(1)
            }
            
        }
        .padding(padding, 53)
        .frame(width: 169)
        .frame(maxWidth: .infinity, alignment: align)
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






