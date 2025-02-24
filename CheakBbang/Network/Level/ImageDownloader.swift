//
//  ImageDownloader.swift
//  CheakBbang
//
//  Created by 박다현 on 2/5/25.
//

import UIKit

final class ImageDownloader: NetworkRequestConvertible {
    typealias api = LevelRouter
    
    // MARK: - CatBookListView의 toy Image용
    func loadImages(for level: Int) async -> [UIImage?] {
        var results = [UIImage?](repeating: nil, count: level + 1)
        let imageCache = NSCache<NSString, UIImage>()
        
        if level < 2 { return results }
        
        await withTaskGroup(of: (Int, UIImage?).self) { group in
            for i in 2...level {
                if let cachedImage = imageCache.object(forKey: "toy_\(i)" as NSString) {
                    results[i] = cachedImage
                    continue
                }
                
                if let img = PhotoFileManager.shared.loadFileImage(filename: "toy_\(i)") {
                    imageCache.setObject(img, forKey: "toy_\(i)" as NSString)
                    results[i] = img
                    continue
                }
                
                group.addTask {
                    let imageData = try? await self.callRequest(api: .toyImage(filename: "toy_\(i).png"), etagKey: "toy_\(i)")
                    
                    if let imageData, let image = UIImage(data: imageData) {
                        PhotoFileManager.shared.saveImageToDocument(image: image, filename: "toy_\(i)", isPNG: true)
                        imageCache.setObject(image, forKey: "toy_\(i)" as NSString)
                        return (i, image)
                    } else {
                        return (i, nil)
                    }
                }
            }
            
            for await (index, image) in group {
                results[index] = image
            }
        }
        
        return results
    }
    
    // MARK: - SettingView의 toy Image용
    func loadImages(for level: [LevelModel]) async -> [UIImage?] {
        var results = [UIImage?](repeating: nil, count: level.count)
        let imageCache = NSCache<NSString, UIImage>()
        
        await withTaskGroup(of: (Int, UIImage?).self) { group in
            for i in 0..<level.count {
                let urlString = level[i].cover
                let fileName = urlString.extractPathWithoutExtension()
                
                if let cachedImage = imageCache.object(forKey: fileName as NSString) {
                    results[i] = cachedImage
                    continue
                }
                
                if let img = PhotoFileManager.shared.loadFileImage(filename: fileName) {
                    imageCache.setObject(img, forKey: fileName as NSString)
                    results[i] = img
                    continue
                }
                
                group.addTask {
                    let imageData = try? await self.callRequest(api: .toyImage(filename: "\(fileName).png"), etagKey: fileName)
                    if let imageData, let image = UIImage(data: imageData) {
                        PhotoFileManager.shared.saveImageToDocument(image: image, filename: fileName)
                        imageCache.setObject(image, forKey: fileName as NSString)
                        
                        return (i, image)
                    } else {
                        return (i, nil)
                    }
                }
            }
            
            for await (index, image) in group {
                results[index] = image
            }
        }
        
        return results
    }

}

