//
//  ContentView.swift
//  CheakBbang
//
//  Created by 박다현 on 9/13/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            CatBookListView()
                .tabItem {
                    Image(systemName: "1.square.fill")
                    Text("First")
                }
            NavigationLazyView(SearchView(viewModel: SearchViewModel()))
                .tabItem {
                    Image(systemName: "2.square.fill")
                    Text("Second")
                }
            NavigationLazyView(MyLibraryView())
                .tabItem {
                    Image(systemName: "3.square.fill")
                    Text("third")
                }
        }
    }
}


#Preview {
    ContentView()
}

