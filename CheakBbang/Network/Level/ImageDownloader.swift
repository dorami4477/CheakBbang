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
    func loadImages(for level: Int) async {
        await withTaskGroup(of: (Int, Data?).self) { group in
            for i in 1...level {
                if PhotoFileManager.shared.loadFileURL(filename: "toy_\(i)") != nil {
                    continue
                }
                
                group.addTask {
                    let imageData = try? await self.callRequest(api: .toyImage(filename: "toy_\(i).png"), etagKey: "toy_\(i)")
                    return (i - 1, imageData)
                }
            }
            
            for await (index, result) in group {
                if let imageData = result, let image = UIImage(data: imageData) {
                    PhotoFileManager.shared.saveImageToDocument(image: image, filename: "toy_\(index + 1)")
                }
            }
        }
    }
    
    // MARK: - SettingView의 toy Image용
    func loadImages(for level: [LevelModel]) async -> [UIImage?] {
        var results = [UIImage?](repeating: nil, count: level.count)
        
        await withTaskGroup(of: (Int, Data?).self) { group in
            for i in 0..<level.count {
                let urlString = level[i].cover
                let fileName = urlString.extractPathWithoutExtension()
                
                if let img = PhotoFileManager.shared.loadFileImage(filename: fileName) {
                    results[i] = img
                    continue
                }
                
                group.addTask {
                    let imageData = try? await self.callRequest(api: .toyImage(filename: "\(fileName).png"), etagKey: fileName)
                    return (i, imageData)
                }
            }
            
            for await (index, result) in group {
                if let imageData = result, let image = UIImage(data: imageData) {
                    results[index] = image
                    
                    let name = level[index].cover.extractPathWithoutExtension()
                    PhotoFileManager.shared.saveImageToDocument(image: image, filename: name)
                }
            }
        }

        return results
    }
}

