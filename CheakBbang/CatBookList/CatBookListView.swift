//
//  CatBookListView.swift
//  CheakBbang
//
//  Created by 박다현 on 9/10/24.
//

import SwiftUI

struct CatBookListView: View {
    var body: some View {
        NavigationView {
            VStack{
                Text("Hello, world!")
                    .transformEffect(CGAffineTransform(1.0, 0.18, 0, 1, 0, 0))
                NavigationLink {
                    NavigationLazyView(SearchView())
                } label: {
                    Text("이동")
                }
            }


        }
//        .task {
//            do {
//                let value = try await NetworkManager.shared.callRequest(api: .item(id: 9788965966463), model: Book.self)
//                print("Fetched data: \(value)")
//            } catch {
//                print("Error fetching data: \(error)")
//            }
//        }

    }
}

#Preview {
    CatBookListView()
}
