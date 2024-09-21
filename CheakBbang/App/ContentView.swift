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
        NavigationStack{
            TabView(selection: $selectedTab) {
                // NavigationStack {
                CatBookListView()
                //  }
                    .tabItem {
                        Image(systemName: "1.square.fill")
                        Text("First")
                    }
                    .tag(0)
                
                // NavigationView {
                NavigationLazyView(MyLibraryView())
                // }
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

