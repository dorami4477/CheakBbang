//
//  CatBookListView.swift
//  CheakBbang
//
//  Created by 박다현 on 9/10/24.
//

import SwiftUI
import RealmSwift

struct TestList: Hashable {
    let id: Int
    let title: String
}


struct CatBookListView: View {
    @ObservedResults(MyBook.self) var bookList
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    ScrollViewReader { proxy in
                        ScrollView {
                            Spacer()
                            LazyVStack {
                                Spacer()
                                ForEach(bookList, id: \.id) { item in
                                    addBook(item: item, align: .leading, padding: .leading)
                                        .id(item.id)
                                        .onTapGesture {
                                            $bookList.remove(item)
                                        }
                                }
                                .padding(.bottom, -29)
                                .scaleEffect(y: -1)

                                Spacer()
                            }
                            .background(.gray)
                            .frame(minHeight: geometry.size.height)
                            .scaleEffect(y: -1)
                            
                            
                        }
                        .onAppear {
//                            DispatchQueue.main.async {
//                                if let anchorId = bookList.last?.startDate {
//                                    proxy.scrollTo(dataString(date: anchorId), anchor: .bottom)
//                                }
//                            }
                        }
                    }
                    VStack{
                        Button("추가") {
                            let newItem = MyBook(id: Int.random(in: 1...100000), title: "타이틀입니다아", originalTitle: "타이틀입니다아타이틀입니다아", author: "타이틀입니다아", publisher: "타이틀입니다아", pubDate: "타이틀입니다아", explanation: "타이틀입니다아타이틀입니다아", cover: "타이틀입니다아", isbn13: "타이틀입니다아", rank: 3, status: .ing, startDate: Date(), endDate: Date())
                            $bookList.append(newItem)
                        }
                        floatingButton()
                    }
                }
            }
        }
        
        
    }

    func addBook(item: MyBook, align: Alignment, padding:Edge.Set) -> some View {
        ZStack {
            Image("sampleBook")
                .resizable()
            Text(item.title.truncate(length: 12))
                .font(.subheadline)
                .foregroundStyle(.white)
                .transformEffect(CGAffineTransform(1.0, 0.078, 0, 1, 0, 0))
                .padding(.leading, 3)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(width: 250, height: 55)
        //.padding(padding, 30)
        //.frame(maxWidth: .infinity, alignment: align)
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
