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
                CatBookListView(viewModel: CatBookListViewModel())
            }
            .tabItem {
                Image(TabbarImageName.tag01)
                Text("북타워")
            }
            .tag(0)
            
            NavigationStack {
                NavigationLazyView(MyLibraryView())
            }
            .tabItem {
                Image(TabbarImageName.tag02)
                Text("내서재")
            }
            .tag(1)
            
            NavigationStack {
                NavigationLazyView(MemoListWrapper())
            }
            .tabItem {
                Image(TabbarImageName.tag03)
                Text("메모서랍")
            }
            .tag(2)
            
            NavigationStack {
                NavigationLazyView(SettingView(viewModel: SettingViewModel()))
            }
            .tabItem {
                Image(TabbarImageName.tag04)
                Text("마이페이지")
            }
            .tag(3)
        }
    }
    
}


#Preview {
    ContentView()
}

