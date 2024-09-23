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

        //let targetSize = UIScreen.main.bounds.size
        let targetSize = CGSize(width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.width - 40)
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            
            view?.frame = CGRect(origin: .zero, size: targetSize) // 프레임 설정
            view?.backgroundColor = .clear // 배경 투명 설정
            view?.drawHierarchy(in: CGRect(origin: .zero, size: targetSize), afterScreenUpdates: true)
            //view?.drawHierarchy(in: view!.bounds, afterScreenUpdates: true)
        }
    }
    
    /*
    func asUIImage() -> UIImage? {
        let controller = UIHostingController(rootView: self)
        let view = controller.view
        
        let targetSize = CGSize(width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.width - 40)
        
        // UIView의 크기를 설정
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear
        view?.sizeToFit()

        // UIGraphicsImageRenderer를 사용하여 클리핑된 이미지를 생성
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { context in
            // 클리핑 영역 설정 (여기서는 전체 영역)
            context.cgContext.addRect(CGRect(origin: .zero, size: targetSize))
            context.cgContext.clip()
            view?.layer.render(in: context.cgContext)
        }
    }
     */
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
