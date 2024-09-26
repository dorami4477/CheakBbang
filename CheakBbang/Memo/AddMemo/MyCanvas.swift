//
//  MyCanvas.swift
//  CheakBbang
//
//  Created by 박다현 on 9/21/24.
//

import SwiftUI
import PencilKit
import PhotosUI

struct MyCanvas: UIViewRepresentable {
    @Binding var canvasView: PKCanvasView
    var backgroundImage: UIImage?

    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.drawingPolicy = .anyInput
        canvasView.tool = PKInkingTool(.marker, color: .accent.withAlphaComponent(0.4), width: 22)
        return canvasView
    }

    func updateUIView(_ canvasView: PKCanvasView, context: Context) {
        if let image = backgroundImage {
            let imageView = UIImageView(image: image)
            imageView.frame = canvasView.bounds
            canvasView.addSubview(imageView)
            canvasView.sendSubviewToBack(imageView)
        }
    }
}
