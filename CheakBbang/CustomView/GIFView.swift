//
//  GIFView.swift
//  CheakBbang
//
//  Created by 박다현 on 9/27/24.
//

import SwiftUI

import ImageIO

struct GIFView: UIViewRepresentable {
    let gifName: String
    let width: CGFloat

    func makeUIView(context: Context) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }

    func updateUIView(_ uiView: UIImageView, context: Context) {
        if let gifUrl = Bundle.main.url(forResource: gifName, withExtension: "gif") {
            let data = try? Data(contentsOf: gifUrl)
            let source = CGImageSourceCreateWithData(data! as CFData, nil)
            let count = CGImageSourceGetCount(source!)
            
            uiView.animationImages = (0..<count).compactMap {
                CGImageSourceCreateImageAtIndex(source!, $0, nil).map {
                    return resize(image: UIImage(cgImage: $0), newWidth: width)
                }
            }
            uiView.animationDuration = Double(count) / 24.0
            uiView.startAnimating()
            
            
        }
    }
    
    func resize(image: UIImage, newWidth: CGFloat) -> UIImage {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale

        let size = CGSize(width: newWidth, height: newHeight)
        let render = UIGraphicsImageRenderer(size: size)
        let renderImage = render.image { context in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
        
        return renderImage
    }
}
