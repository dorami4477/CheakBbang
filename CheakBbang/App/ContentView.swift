//
//  ContentView.swift
//  CheakBbang
//
//  Created by 박다현 on 9/13/24.
//

import SwiftUI

struct ContentView: View {
    init() {
      UITabBar.appearance().backgroundColor = .white
    }
    
    var body: some View {
        NavigationView {
            TabView {
                CatBookListView()
                    .tabItem {
                        Image(systemName: "1.square.fill")
                        Text("First")
                    }
                NavigationLazyView(MyLibraryView())
                    .tabItem {
                        Image(systemName: "2.square.fill")
                        Text("Second")
                    }
            }
        }
    }
}


#Preview {
    ContentView()
}

