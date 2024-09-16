//
//  CheakBbangApp.swift
//  CheakBbang
//
//  Created by 박다현 on 9/10/24.
//

import SwiftUI
import RealmSwift

@main
struct CheakBbangApp: App {
    @ObservedObject var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .id(appState.rootViewId)
                .environmentObject(appState)
        }
    }
}


final class AppState : ObservableObject {
    @Published var rootViewId = UUID()
}
