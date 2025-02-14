//
//  OCRView.swift
//  CheakBbang
//
//  Created by 박다현 on 9/20/24.
//

import PhotosUI
import SwiftUI
import Vision

struct OCRView: View {
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var image: Image? = nil
    @State var recognizedText = ""
    @State private var isCustomCameraViewPresented = false
    
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

        


//        VStack{
//            Spacer()
//            Button(action: {isCustomCameraViewPresented.toggle()}, label: {Image(systemName: "camera.fill").font(.largeTitle).padding().background(Color.black).foregroundColor(.white).clipShape(Circle())}).padding(.bottom).sheet(isPresented: $isCustomCameraViewPresented, content: {CustomCameraView(capturedImage: $image)})
//            // 실시간으로 카메라 영상이 보이는 화면 표시
//        }
            


    }
    
    func ocr(_ image: Image) {
        guard let uiImage = image.asUIImage() else { return }
        
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
