//
//  CatBookListView.swift
//  CheakBbang
//
//  Created by 박다현 on 9/10/24.
//

import SwiftUI

struct TestList: Hashable {
    let id: Int
    let title: String
}


struct CatBookListView: View {
    @State private var list: [TestList] = []
    let background = Color.blue
    
    var body: some View {
        NavigationView {
                ScrollViewReader { proxy in
                    ScrollView{
                        LazyVStack {
                            ForEach(list, id: \.id) { item in
                                if item.id > 5 {
                                    addBook(item: item, align: .leading, padding: .leading)
                                        .id(item.id)
                                } else {
                                    addBook(item: item, align: .trailing, padding: .trailing)
                                        .id(item.id)
                                }
                                
                            }
                            .padding(.bottom, -50)
                            .scaleEffect(y: -1)
                        }
                        .scaleEffect(y: -1)
                    }
                    
                    .onAppear {
                        for number in 0..<10 {
                            list.append(TestList(id: number, title: "dfdddd-\(number)"))
                        }
                        DispatchQueue.main.async {
                            if let anchorId = list.last?.id {
                                proxy.scrollTo(anchorId)
                            }
                        }
                    }
                }
            
            
//            VStack{
//                Button("책추가") {
//                    //addBook()
//                }
//                NavigationLink {
//                    NavigationLazyView(SearchView())
//                } label: {
//                    Text("이동")
//                }
//            }
        }
    }
    
    func addBook(item: TestList, align: Alignment, padding:Edge.Set) -> some View {
        ZStack {
            Image("testBook")
                .resizable()
                .frame(width: 100, height: 100)
            Text(item.title)
                .transformEffect(CGAffineTransform(1.0, 0.18, 0, 1, 0, 0))
        }
        .padding(padding, 30)
        .frame(maxWidth: .infinity, alignment: align)
    }
}

#Preview {
    CatBookListView()
}
