//
//  ImageDownloader.swift
//  CheakBbang
//
//  Created by 박다현 on 2/5/25.
//

import Foundation

import Alamofire

final class ImageDownloader {
    func downloadImage(from urlString: String) async throws -> Data? {
        guard let url = URL(string: urlString) else {
            return nil
        }

        let data = try await withCheckedThrowingContinuation { continuation in
            AF.request(url)
                .validate()
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        continuation.resume(returning: data)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        }

        return data
    }

    func loadImages(for level: Int) async {
        var results = [Data?](repeating: nil, count: level)
        
        await withTaskGroup(of: (Int, Data?).self) { group in
            for i in 1...level {
                let urlString = "\(APIKeys.itemBaseUrl)/toy_\(i).png"
                
                if PhotoFileManager.shared.loadFileURL(filename: "toy_\(i)") != nil {
                    continue
                }
                
                group.addTask {
                    let imageData = try? await self.downloadImage(from: urlString)
                    return (i - 1, imageData)
                }
            }
            
            for await (index, result) in group {
                results[index] = result
            }
        }
        
        for (index, image) in results.enumerated() {
            if let image = image {
                PhotoFileManager.shared.saveImageDataToDocument(data: image, filename: "toy_\(index + 1)")
            }
        }
    }
}

