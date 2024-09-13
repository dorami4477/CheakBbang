//
//  AddBookAniView.swift
//  CheakBbang
//
//  Created by 박다현 on 9/13/24.
//

import SwiftUI

struct AddBookAniView: View {

    @EnvironmentObject var appState: AppState
    
    var body: some View {
        Button("루트로 돌아가기") {
            appState.rootViewId = UUID()
        }
    }
}

#Preview {
    AddBookAniView()
}
