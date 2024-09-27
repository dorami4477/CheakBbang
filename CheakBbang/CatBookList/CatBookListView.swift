//
//  CatBookListView.swift
//  CheakBbang
//
//  Created by 박다현 on 9/10/24.
//

import SwiftUI
import RealmSwift

struct CatBookListView: View {
    @StateObject var viewModel = CatBookListViewModel()
    @State private var showBubble = false
    @State private var txtBubble: TextBubble = .phrase1
    
    var body: some View {
        GeometryReader { geometry in
            ZStack{
                Image(ImageName.background)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                VStack(spacing: 5) {
                    infoView()
                    ZStack {
                        VStack{
                            ScrollView(.vertical) {
                               // let safeAreaInsets = geometry.safeAreaInsets
                               // let heightWithoutSafeArea = geometry.size.height - safeAreaInsets.top - safeAreaInsets.bottom
                                let itemHeight = geometry.size.width * 0.86 + viewModel.output.totalBookHeight - viewModel.output.groupBottomPadding - CGFloat((viewModel.output.bookCount - viewModel.output.bookCount / 5) * 15)
                                let space = (geometry.size.height - itemHeight) - 30
                               // Text("\(space), \(viewModel.output.totalBookHeight), \(viewModel.output.groupBottomPadding)")
                                if 0 < space {
                                    Spacer(minLength: space)
                                }
                                bookListView()
                                Image(ImageName.bottom)
                                    .resizable()
                                    .frame(width: geometry.size.width, height: geometry.size.width * 0.86)
                            }
                        }
                        VStack{
                            floatingButton()
                        }
                    }
                }
            }
        }
//        .onAppear {
//            print(Realm.Configuration.defaultConfiguration.fileURL)
//        }
    }
    
    func bookListView() -> some View {
        LazyVStack {
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
    
    func bookRowView(item: MyBook, align: Alignment, padding: Edge.Set, isFirst: Bool, isLast: Bool) -> some View {
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
                        print(showBubble)
                    }
            }
            
            NavigationLink {
                NavigationLazyView(BookDetailView(item: item))
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
        
    func infoView() -> some View {
        HStack{
            VStack {
                Text("Books")
                    .font(.subheadline)
                Text("\(viewModel.output.bookCount)")
                    .bold()
                    .font(.title2)
            }
            
            Spacer()
            if showBubble {
                VStack {
                    Text(txtBubble.rawValue)
                        .font(.system(size: 15))
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
                Text("\(viewModel.output.totalPage)")
                    .bold()
                    .font(.title2)
            }
        }
        .padding(.horizontal, 30)
        .frame(maxWidth: .infinity)
        .frame(height: 30)
    }
    
}


struct floatingButton: View {
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                NavigationLink(destination: NavigationLazyView(SearchView(viewModel: SearchViewModel()))) {
                    Image(systemName: "plus")
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .shadow(radius: 4)
                }
                .padding()
            }
        }
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


