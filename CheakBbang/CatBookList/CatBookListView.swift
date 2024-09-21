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
    
    var body: some View {
        GeometryReader { geometry in
            ZStack{
                Image(ImageName.background)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                VStack(spacing: 5) {
                    infoView()
                    ZStack(alignment: .bottom) {
                        VStack{
                            ScrollView(.vertical) {
                                let safeAreaInsets = geometry.safeAreaInsets
                                let heightWithoutSafeArea = geometry.size.height - safeAreaInsets.top - safeAreaInsets.bottom
                                let itemHeight = geometry.size.width * 0.86 + viewModel.output.totalBookHeight - viewModel.output.groupBottomPadding - CGFloat((viewModel.output.bookCount - viewModel.output.bookCount / 5) * 15)
                                let space = heightWithoutSafeArea - itemHeight
                                //Text("\(CGFloat((viewModel.output.bookCount - viewModel.output.bookCount / 5) * 10))")
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
                Image("cat_1")
                    .resizable()
                    .frame(width: 110, height: 73)
                    .zIndex(3)
                    .padding(.bottom, isLast ? -20 : 0)
            }
            
            NavigationLink(value: item) {
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
            .navigationDestination(for: MyBook.self) { item in
                NavigationLazyView(BookDetailView(item: item))
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


