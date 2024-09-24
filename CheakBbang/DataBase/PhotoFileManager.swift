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
    func saveImageToDocument(image: UIImage, filename: String) {
        
        guard let documentDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first else {
            print("Failed to get document directory")
            return
        }

        let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")

        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            print("Failed to convert image to JPEG data")
            return
        }

        do {
            try imageData.write(to: fileURL)
            print("Image saved successfully at: \(fileURL)")
        } catch {
            print("Failed to save image: \(error)")
        }
    }

    //get FileURL
    func loadFileURL(filename: String) -> URL? {
        guard let documentDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first else { return nil }
        
        let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")
        return fileURL
    }
    
    
    //Delete
    func removeImageFromDocument(filename: String) {
        DispatchQueue.global().async {
            guard let documentDirectory = FileManager.default.urls(
                for: .documentDirectory,
                in: .userDomainMask).first else { return }

            let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")
            
            if FileManager.default.fileExists(atPath: fileURL.path) {
                
                do {
                    try FileManager.default.removeItem(atPath: fileURL.path)

                } catch {
                    print("file remove error", error)
                }
                
            } else {
                print("file no exist")
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
