//
//  RratingHeartView.swift
//  CheakBbang
//
//  Created by 박다현 on 9/18/24.
//

import SwiftUI
import Cosmos

// A SwiftUI wrapper for Cosmos view
struct RratingHeartView: UIViewRepresentable {
    @Binding var rating: Double

    func makeUIView(context: Context) -> CosmosView {
        CosmosView()
    }

    func updateUIView(_ uiView: CosmosView, context: Context) {
        uiView.rating = rating

        uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        uiView.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        uiView.settings.starSize = 30
        uiView.settings.fillMode = .precise
        uiView.settings.filledImage = UIImage(named: "icon_heart_01")
        uiView.settings.emptyImage = UIImage(named: "icon_heart_03")
 
        
    }
}

