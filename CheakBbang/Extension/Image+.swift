//
//  Image+.swift
//  CheakBbang
//
//  Created by 박다현 on 9/21/24.
//

import SwiftUI

extension Image {
    func toUIImage() -> UIImage? {
        let controller = UIHostingController(rootView: self)
        let view = controller.view
        
        let targetSize = CGSize(width: 300, height: 300) // 원하는 크기로 설정
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        
        return renderer.image { _ in
            view?.bounds = CGRect(origin: .zero, size: targetSize)
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
}
