//
//  PhotoFileManager.swift
//  CheakBbang
//
//  Created by 박다현 on 9/12/24.
//

import SwiftUI

final class PhotoFileManager{
    static let shared = PhotoFileManager()
    private init() {}
    
    //Create
    func saveImageToDocument(image: UIImage, filename: String, isPNG: Bool = false) {
        guard let documentDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first else {
                print("Failed to get document directory")
                return
        }

        let timestamp = Int(Date().timeIntervalSince1970)
        let fileExtension = isPNG ? "png" : "jpg"
        let fileNameWithTimestamp = "\(filename)_\(timestamp).\(fileExtension)"
        
        let fileURL = documentDirectory.appendingPathComponent(fileNameWithTimestamp)
        
        var imageData: Data?
        
        if isPNG {
            imageData = image.pngData()
        } else {
            imageData = image.jpegData(compressionQuality: 0.5)
        }
        
        guard let data = imageData else {
            print("Failed to convert image to \(fileExtension.uppercased()) data")
            return
        }
        
        do {
            let fileManager = FileManager.default
            let files = try fileManager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)

            for file in files {
                if file.lastPathComponent.hasPrefix(filename) {
                    try fileManager.removeItem(at: file)
                    break
                }
            }

            try data.write(to: fileURL, options: .atomic)
        } catch {
            print("Failed to save image: \(error)")
        }
    }

    
    func saveStringImageToDocument(imageURL: String, filename: String) {
        guard let url = URL(string: imageURL) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("Failed to download image: \(error)")
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                print("Failed to create image from data")
                return
            }
            
            self?.saveImageToDocument(image: image, filename: filename)
        }
        task.resume()
    }

    //get FileURL
    func loadFileURL(filename: String) -> URL? {
        guard let documentDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first else { return nil }

        do {
            let files = try FileManager.default.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
            let matchedFiles = files.filter { $0.lastPathComponent.hasPrefix(filename) }
    
            if let latestFile = matchedFiles.sorted(by: { $0.lastPathComponent.compare($1.lastPathComponent, options: .numeric) == .orderedDescending }).first {
                return latestFile
            }
        } catch {
            print("Failed to get file list: \(error)")
        }
        
        return nil
    }
    
    func loadFileImage(filename: String) -> UIImage? {
        guard let documentDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first else {
            print("Failed to get document directory")
            return nil
        }

        let fileManager = FileManager.default
        do {
            let files = try fileManager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
            for file in files {
                if file.lastPathComponent.hasPrefix(filename) {
                    if let image = UIImage(contentsOfFile: file.path) {
                        return image
                    }
                }
            }
        } catch {
            print("Failed to load image: \(error)")
        }
        
        return nil
    }

    //Delete
    func removeImageFromDocument(filename: String) {
        DispatchQueue.global().async {
            guard let documentDirectory = FileManager.default.urls(
                for: .documentDirectory,
                in: .userDomainMask).first else { return }

            let fileManager = FileManager.default
            do {
                let files = try fileManager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
                
                for file in files {
                    if file.lastPathComponent.hasPrefix(filename) {
                        try fileManager.removeItem(at: file)
                        break
                    }
                }
            } catch {
                print("Failed to remove image: \(error)")
            }
        }
    }
    
    //Delete All
    func removeAllImagesFromDocument() {
        DispatchQueue.global().async {
            guard let documentDirectory = FileManager.default.urls(
                for: .documentDirectory,
                in: .userDomainMask).first else { return }

            do {
                let fileURLs = try FileManager.default.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
                
                for fileURL in fileURLs {
                    if fileURL.pathExtension == "jpg" {
                        do {
                            try FileManager.default.removeItem(at: fileURL)
                        } catch {
                            print("Failed to delete file: \(fileURL.lastPathComponent), error: \(error)")
                        }
                    }
                }
            } catch {
                print("Error fetching files from document directory: \(error)")
            }
        }
    }
}
