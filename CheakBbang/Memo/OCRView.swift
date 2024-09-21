//
//  OCRView.swift
//  CheakBbang
//
//  Created by 박다현 on 9/20/24.
//

import SwiftUI
import Vision
import PhotosUI

struct OCRView: View {
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var image: Image?
    @State var recognizedText = ""
    
    var body: some View {
        VStack {
            image?
                .resizable()
                .scaledToFit()
            
            PhotosPicker(
                selection: $selectedPhoto,
                matching: .all(of: [.screenshots, .images])
            ) {
                Image(systemName: "pencil")
            }
            .onChange(of: selectedPhoto) { newItem in
                Task {
                    guard let newItem = newItem else { return }
                    do {
                        image = try await newItem.loadTransferable(type: Image.self)
                        print("Image loaded successfully")
                    } catch {
                        print("Error loading image: \(error)")
                    }
                }
            }
            
            Button("Recognize Text"){
                guard let image else { return }
                ocr(image)
            }
            
            TextEditor(text: $recognizedText)
        }



    }
    
    func ocr(_ image: Image) {
        guard let uiImage = image.toUIImage() else { return }
        
        if let cgImage = uiImage.cgImage {
            
            // Request handler
            let handler = VNImageRequestHandler(cgImage: cgImage)
            
            let recognizeRequest = VNRecognizeTextRequest { (request, error) in
                
                // Parse the results as text
                guard let result = request.results as? [VNRecognizedTextObservation] else {
                    return
                }
                
                // Extract the data
                let stringArray = result.compactMap { result in
                    result.topCandidates(1).first?.string
                }
                
                // Update the UI
                DispatchQueue.main.async {
                    recognizedText = stringArray.joined(separator: "\n")
                }
            }
            
            recognizeRequest.revision = VNRecognizeTextRequestRevision3
            recognizeRequest.recognitionLanguages = ["ko-KR"]
            recognizeRequest.recognitionLevel = .accurate
            
            do {
                try handler.perform([recognizeRequest])
            } catch {
                print(error)
            }
            
        }
    }
}
