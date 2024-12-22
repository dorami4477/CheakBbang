//
//  Image+.swift
//  CheakBbang
//
//  Created by 박다현 on 9/21/24.
//

import SwiftUI

extension Image {
    func asUIImage() -> UIImage? {
        let controller = UIHostingController(rootView: self)
        let view = controller.view
        
        let targetSize = CGSize(width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.width - 40)
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            view?.drawHierarchy(in: view!.bounds, afterScreenUpdates: true)
        }
    }
}


extension UIImage {
    convenience init?(color: UIColor, size: CGSize) {
        UIGraphicsBeginImageContext(size)
        color.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.init(cgImage: image!.cgImage!)
    }
    
    func cropToAspectRatio(aspectRatio: CGFloat) -> UIImage? {
        var normalizedImage = self
        if self.imageOrientation != .up {
            normalizedImage = self.correctOrientation()
        }
        
        let width = normalizedImage.size.width
        let height = normalizedImage.size.height

        var cropWidth: CGFloat
        var cropHeight: CGFloat

        if width / height > aspectRatio {
            cropHeight = height
            cropWidth = cropHeight * aspectRatio
        } else {
            cropWidth = width
            cropHeight = cropWidth / aspectRatio
        }

        let cropRect = CGRect(
            x: (width - cropWidth) / 2,
            y: (height - cropHeight) / 2,
            width: cropWidth,
            height: cropHeight
        )

        guard let cgImage = normalizedImage.cgImage?.cropping(to: cropRect) else {
            return nil
        }

        return UIImage(cgImage: cgImage)
    }

    private func correctOrientation() -> UIImage {
        if imageOrientation == .up {
            return self
        }
        
        var transform = CGAffineTransform.identity
        
        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.rotated(by: .pi)
        case .left, .leftMirrored:
            transform = transform.rotated(by: .pi / 2)
        case .right, .rightMirrored:
            transform = transform.rotated(by: -.pi / 2)
        default:
            break
        }
        
        let size = CGSize(width: self.size.width, height: self.size.height)
        UIGraphicsBeginImageContext(size)
        guard let context = UIGraphicsGetCurrentContext() else { return self }
        
        context.concatenate(transform)

        self.draw(in: CGRect(origin: .zero, size: size))
        let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return rotatedImage ?? self
    }

}
