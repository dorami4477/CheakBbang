//
//  MyLibraryView.swift
//  CheakBbang
//
//  Created by 박다현 on 9/14/24.
//

import SwiftUI

struct MyLibraryView: View {
    @State private var activeTab: LibraryTab = .all

    var body: some View {
        VStack(spacing: 15) {
            TabBarView(selectedTab: $activeTab)
                .padding([.horizontal, .top], 15)

            TabView(selection: $activeTab) {
                AllLibraryView(viewModel: LibraryViewModel())
                    .tag(LibraryTab.all)
                
                NavigationLazyView(LibraryView(viewModel: LibraryViewModel(), status: .ing))
                    .tag(LibraryTab.currenltyReading)
                
                NavigationLazyView(LibraryView(viewModel: LibraryViewModel(), status: .done))
                    .tag(LibraryTab.done)
                
                NavigationLazyView(LibraryView(viewModel: LibraryViewModel(), status: .will))
                    .tag(LibraryTab.wantToRead)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            //.allowsHitTesting(false)
        }

    }
}

struct TabBarView: View {
    @Binding var selectedTab: LibraryTab
    @Namespace private var animationNamespace
    @State private var tabSizes: [LibraryTab: CGSize] = [:]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(LibraryTab.allCases, id: \.self) { tab in
                GeometryReader { geometry in
                    Text(tab.rawValue)
                        .font(.caption)
                        .fontWeight(selectedTab == tab ? .semibold : .regular)
                        .foregroundColor(selectedTab == tab ? .white : .gray)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .background(
                            ZStack {
                                if selectedTab == tab {
                                    Capsule()
                                        .fill(Color.black)
                                        .matchedGeometryEffect(id: "tabUnderline", in: animationNamespace)
                                        .frame(width: tabSizes[tab]?.width ?? 0, height: 35)
                                        .transition(.opacity)
                                }
                            }
                        )
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                selectedTab = tab
                            }
                        }
                        .onAppear {
                            tabSizes[tab] = geometry.size
                        }
                        .onChange(of: geometry.size) { newSize in
                            tabSizes[tab] = newSize
                        }
                }
                .frame(height: 40)
            }
        }
        .background(Color.white)
        .clipShape(Capsule())
        .shadow(color: .black.opacity(0.1), radius: 5, x: 5, y: 5)
    }
}


#Preview {
    MyLibraryView()
}
