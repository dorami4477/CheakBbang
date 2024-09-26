//
//  ContentView.swift
//  CheakBbang
//
//  Created by 박다현 on 9/13/24.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    init() {
        UITabBar.appearance().backgroundColor = .white
    }
    
    var body: some View {
            TabView(selection: $selectedTab) {
                NavigationStack {
                    CatBookListView()
                }
                    .tabItem {
                        Image(systemName: "1.square.fill")
                        Text("북타워")
                    }
                    .tag(0)
                
                NavigationStack {
                    NavigationLazyView(MyLibraryView())
                }
                    .tabItem {
                        Image(systemName: "2.square.fill")
                        Text("내서재")
                    }
                    .tag(1)
                
                NavigationStack {
                    NavigationLazyView(MemoListWrapper())
                }
                    .tabItem {
                        Image(systemName: "3.square.fill")
                        Text("메모서랍")
                    }
                    .tag(2)
        }

    }
}


#Preview {
    ContentView()
}

