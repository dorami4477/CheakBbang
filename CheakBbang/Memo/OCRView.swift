//
//  OCRView.swift
//  CheakBbang
//
//  Created by 박다현 on 9/20/24.
//

import SwiftUI
import Vision


struct OCRView: View {
   
    @State var recognizedText = ""
    
    var body: some View {
        VStack {

            Text("OCR using Vission")
                .font(.title)
            
            Image("test")
                .resizable()
                .scaledToFit()
            
            Button("Recognize Text"){
                ocr()
            }
            
            TextEditor(text: $recognizedText)
            
        }
        .padding()
        
        

    }
    
    func ocr() {
        let image = UIImage(named: "test")
        
        if let cgImage = image?.cgImage {
            
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
