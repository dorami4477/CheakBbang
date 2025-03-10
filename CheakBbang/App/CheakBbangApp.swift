//
//  CheakBbangApp.swift
//  CheakBbang
//
//  Created by 박다현 on 9/10/24.
//

import SwiftUI

import FirebaseCore
import RealmSwift

@main
struct CheakBbangApp: App {
    @ObservedObject var appState = AppState()
    @ObservedObject var viewModel = OnboardingViewModel()
    
    init() {
      FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            if viewModel.isFirstRun {
                OnboardingView(viewModel: viewModel)
                    .environmentObject(appState)
            } else {
                ContentView()
                    .id(appState.rootViewId)
                    .environmentObject(appState)
            }
        }
    }
}


final class AppState : ObservableObject {
    @Published var rootViewId = UUID()
}
