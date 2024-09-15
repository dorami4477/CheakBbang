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
    @State private var bookHeight: CGFloat = 0
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack{
                    Image(ImageName.background)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                    VStack{
                        infoView()
                        ZStack(alignment: .bottom) {
                            VStack{
                                ScrollView(.vertical) {
                                    let space = geometry.size.height - (geometry.size.width + bookHeight)
                                    if 0 < space {
                                        Spacer(minLength: space)
                                    }
                                    bookListView()
                                    Text("\(geometry.size.height)-\(geometry.size.width)-\(bookHeight)")
                                    Image(ImageName.bottom)
                                        .resizable()
                                        .frame(width: geometry.size.width, height: geometry.size.width * 0.86)
                                }
                            }
                            VStack{
                                //                            Button("추가") {
                                //                                let newItem = MyBook(itemId: Int.random(in: 1...100000), title: "타이틀입니다아", originalTitle: "타이틀입니다아타이틀입니다아", author: "타이틀입니다아", publisher: "타이틀입니다아", pubDate: "타이틀입니다아", explanation: "타이틀입니다아타이틀입니다아", cover: "타이틀입니다아", isbn13: "타이틀입니다아", rank: 3, page: Int.random(in: 1...500), status: .ing, startDate: Date(), endDate: Date())
                                //                                //viewModel.$realmBookList.append(newItem)
                                //                            }
                                floatingButton()
                            }
                        }
                    }
                }
            }
            .onAppear{
                print("네비게이션 Appear")
                bookHeight = 0
            }
        }

    }
    
    
    func bookListView() -> some View {
        LazyVStack {
            ForEach(Array(zip(viewModel.output.bookList.indices, viewModel.output.bookList)), id: \.1.id) { index, item in
                
                let alignment = viewModel.isLeadingAlignment(for: index) ? Alignment.leading : Alignment.trailing
                let padding = viewModel.isLeadingAlignment(for: index) ? Edge.Set.leading : Edge.Set.trailing
                
                if viewModel.output.bookCount - 1 == index && index % 5 == 0 {
                    bookRowView(item: item, align: alignment, padding: padding, isFirst: true, isLast: true)
                    
                } else if viewModel.output.bookCount - 1 == index && index % 5 != 0 {
                    bookRowView(item: item, align: alignment, padding: padding, isFirst: false, isLast: true)
                    
                } else if index % 5 == 0 {
                    bookRowView(item: item, align: alignment, padding: padding, isFirst: true, isLast: false)
                    
                } else {
                    bookRowView(item: item, align: alignment, padding: padding, isFirst: false, isLast: false)
                }
                
            }
            .scaleEffect(y: -1)
        }
        //.offset(y: 20)
        //.background(Color.blue)
        .scaleEffect(y: -1)
    }
    
    func bookRowView(item: MyBook, align: Alignment, padding: Edge.Set, isFirst: Bool, isLast: Bool) -> some View {
        VStack{
            if isLast {
                Image("cat_1")
                    .resizable()
                    .frame(width: 110, height: 73)
                    .zIndex(3)
                    .padding(.bottom, isLast ? -20 : 0)
            }
            ZStack {
                Image(viewModel.bookImage(item.page))
                    .resizable()
                Text(item.title.truncate(length: 10))
                    .bold()
                    .font(.caption)
                    .foregroundStyle(.white)
                    .transformEffect(CGAffineTransform(1.0, 0.069, 0, 1, 0, 0))
                    .padding(.leading, 6)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(width: 161, height: viewModel.bookImageHeight(item.page))
            .padding(.bottom, isFirst ? -23 : 0)
            .onTapGesture {
                //viewModel.$realmBookList.remove(item)
            }
            .zIndex(2)
            if isFirst {
                Image(ImageName.shelf)
                    .resizable()
                    .frame(width: 169, height: 38)
                    .zIndex(1)
            }

        }
        .padding(padding, 53)
        .frame(width: 169)
        .frame(maxWidth: .infinity, alignment: align)
        .padding(.bottom, -20)
        .onAppear{
            print("BookRow Appear")
            bookHeight = bookHeight + viewModel.bookImageHeight(item.page)
        }
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
