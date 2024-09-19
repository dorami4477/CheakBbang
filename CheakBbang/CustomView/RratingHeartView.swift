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
    var isEditable = true
    var size = 30.0

    func makeUIView(context: Context) -> CosmosView {
        CosmosView()
    }

    func updateUIView(_ uiView: CosmosView, context: Context) {
        uiView.rating = rating
        
        uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        uiView.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        uiView.settings.starSize = size
        uiView.settings.fillMode = .precise
        uiView.settings.filledImage = UIImage(named: ImageName.ratingHeartFill)
        uiView.settings.emptyImage = UIImage(named: ImageName.ratingHeart)
 
        uiView.didFinishTouchingCosmos = { rate in
            rating = rate
        }
        
        if !isEditable {
            uiView.settings.updateOnTouch = false
        }
    }
}

