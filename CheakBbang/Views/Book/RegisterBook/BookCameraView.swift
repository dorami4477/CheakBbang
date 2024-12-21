//
//  BookCameraView.swift
//  CheakBbang
//
//  Created by 박다현 on 12/21/24.
//

import SwiftUI
import AVFoundation

struct BookCameraView : View {
    @Environment(\.presentationMode) private var presentationMode
    @Binding var capturedImage : UIImage?
    @State private var cameraService = CameraService()
    
    private let cameraSizeWidth: CGFloat = UIScreen.main.bounds.width - 40
    
    
    var body: some View{
        VStack{
            Text(capturedImage == nil ? "도서의 커버를 찍어주세요." : "")
                .foregroundStyle(.gray)
                .font(.system(size: 14))
            
            if let image = capturedImage {
                ZStack {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                    
                }
                .frame(width: cameraSizeWidth, height: cameraSizeWidth * 1.6)
                .clipped()
                
                Text("다시 찍기")
                    .wrapToButton {
                        capturedImage = nil
                        self.cameraService = CameraService()
                    }
                
                Text("저장")
                    .asfullCapsuleButton(background: .accent)
                    .wrapToButton {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .padding()
            } else {
                CameraView(cameraService: cameraService, cameraSize: (cameraSizeWidth, cameraSizeWidth * 1.6)) { result in
                    switch result{
                    case .success(let photo):
                        if let data = photo.fileDataRepresentation(){
                            capturedImage = UIImage(data : data)
                            
                        }else{
                            print("Error : no image data found")
                        }
                    case .failure(let err):
                        print(err.localizedDescription)
                    }
                }
                .frame(width: cameraSizeWidth, height: cameraSizeWidth * 1.6)
                
                Button(action: {
                    cameraService.capturePhoto()
                }, label: {
                    Image(systemName: "circle")
                        .font(.system(size: 72))
                        .foregroundColor(.black)
                })
                
            }
        }
        
    }
        
        private func savePhoto() {
            let targetSize = CGSize(width: cameraSizeWidth, height: cameraSizeWidth * 1.6)
            if let capturedImage, let resizedImage = resizeImage(image: capturedImage, targetSize: targetSize) {
                self.capturedImage = resizedImage
            }
            
        }
        
        private func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
            let size = image.size
            let widthRatio = targetSize.width / size.width
            let heightRatio = targetSize.height / size.height
            
            let scaleFactor = min(widthRatio, heightRatio)
            let newSize = CGSize(width: size.width * scaleFactor, height: size.height * scaleFactor)
            
            UIGraphicsBeginImageContextWithOptions(newSize, false, image.scale)
            image.draw(in: CGRect(origin: .zero, size: newSize))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return resizedImage
        }
    }
