//
//  CatBookListView.swift
//  CheakBbang
//
//  Created by 박다현 on 9/10/24.
//

import SwiftUI
import RealmSwift


struct CatBookListView: View {
    @ObservedResults(MyBook.self) var bookList
    @State private var bookCount = 1
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                        ScrollView {
                                LazyVStack {
                                    ForEach(Array(bookList.enumerated()), id: \.element.id) { index, item in
                                        let share = index / 5
                                        
                                        if share % 2 == 0 {
                                            if index % 5 == 0 {
                                                addBook(item: item, align: .leading, padding: .leading, isFirst: true)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                //.padding(.bottom, -50)
                                                    .id(item.id)
                                            } else {
                                                addBook(item: item, align: .leading, padding: .leading, isFirst: false)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                    .id(item.id)
                                            }
                                            
                                        } else if share % 2 == 1 {
                                            if index % 5 == 0 {
                                                addBook(item: item, align: .trailing, padding: .trailing, isFirst: true)
                                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                                //.padding(.bottom, -50)
                                                    .id(item.id)
                                            } else {
                                                addBook(item: item, align: .trailing, padding: .trailing, isFirst: false)
                                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                                    .id(item.id)
                                            }
                                        }
                                    }
                                    .padding(.bottom, -20)
                                    .scaleEffect(y: -1)
                                }
                                .frame(minHeight: geometry.size.height)
                                .scaleEffect(y: -1)
                        }
                    VStack{
                        Button("추가") {
                            let newItem = MyBook(itemId: Int.random(in: 1...100000), title: "타이틀입니다아", originalTitle: "타이틀입니다아타이틀입니다아", author: "타이틀입니다아", publisher: "타이틀입니다아", pubDate: "타이틀입니다아", explanation: "타이틀입니다아타이틀입니다아", cover: "타이틀입니다아", isbn13: "타이틀입니다아", rank: 3, page: Int.random(in: 1...500), status: .ing, startDate: Date(), endDate: Date())
                            $bookList.append(newItem)
                        }
                        HStack{
                            VStack {
                                Text("Volume")
                                Text("\($bookList.wrappedValue.count)")
                            }
                            Spacer()
                            VStack {
                                Text("Total Pages")
                                Text("\(getTotalPage())")
                            }
                        }
                        .padding(.horizontal, 30)
                        .frame(maxWidth: .infinity)
                        floatingButton()
                    }
                }
            }
        }
    }

    func addBook(item: MyBook, align: Alignment, padding:Edge.Set, isFirst:Bool) -> some View {
        VStack{
            ZStack {
                bookImage(item.page)
                    .resizable()
                Text(item.title.truncate(length: 10))
                    .bold()
                    .font(.caption)
                    .foregroundStyle(.white)
                    .transformEffect(CGAffineTransform(1.0, 0.078, 0, 1, 0, 0))
                    .padding(.leading, 6)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(width: 146, height: bookImageHeight(item.page))
            .padding(.bottom, isFirst ? -25 : 0)
            .onTapGesture {
                $bookList.remove(item)
            }
            .zIndex(align == .leading ? 2 : 5)
            if isFirst {
                Image("shelf")
                    .resizable()
                    .frame(width: 212, height: 43)
                    .zIndex(align == .leading ? -1 : 4)
            }
        }
        .padding(padding, 30)
        .frame(width: 212)
        
    }
    
    func bookImage(_ page: Int) -> Image {
        let randomColor = Int.random(in: 1...4)
        
        switch page {
        case 0..<100:
            return Image("book_\(randomColor)_01")
        case 100..<200:
            return Image("book_\(randomColor)_02")
        case 200..<300:
            return Image("book_\(randomColor)_03")
        case 300..<400:
            return Image("book_\(randomColor)_04")
        case 400...:
            return Image("book_\(randomColor)_05")
        default:
            return Image("book_\(randomColor)_01")
        }
    }
    
    func bookImageHeight(_ page: Int) -> CGFloat {
        
        switch page {
        case 0..<100:
            return 30
        case 100..<200:
            return 35
        case 200..<300:
            return 38
        case 300..<400:
            return 43
        case 400...:
            return 50
        default:
            return 30
        }
    }
    
    func getTotalPage() -> String{
        var totalPage = 0
        $bookList.wrappedValue.forEach {
            totalPage += $0.page
        }
        return totalPage.formatted()
    }
    
    func dataString(date: Date) -> String {
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "yyyyMMddHHmmss"
        let savedDateString = myFormatter.string(from: date)
        return savedDateString
    }

}
//#Preview {
//    CatBookListView()
//}

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
