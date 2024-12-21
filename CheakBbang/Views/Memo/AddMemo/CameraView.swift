//
//  CameraView.swift
//  CheakBbang
//
//  Created by 박다현 on 9/21/24.
//

import SwiftUI
import AVFoundation
import PencilKit

struct CustomCameraView : View {
    let cameraService = CameraService()
    @Binding var imageWithPen : UIImage?
    @State var capturedImage : UIImage?
    @Environment(\.presentationMode) private var presentationMode
    
    @Environment(\.undoManager) private var undoManager
    @State private var canvasView = PKCanvasView()
    let cameraSize: CGFloat = UIScreen.main.bounds.width - 40
    
    var body: some View{
        VStack{
            Text(capturedImage == nil ? "간직하고 싶은 페이지를 촬영해주세요." : "마음에 드는 글귀에 밑줄을 그어주세요.")
                .foregroundStyle(.gray)
                .font(.system(size: 14))
            
            if let image = capturedImage {
                ZStack {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                    
                    MyCanvas(canvasView: $canvasView, backgroundImage: capturedImage)
                    
                }
                .frame(width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.width - 40)
                .clipped()
                
                VStack{
                    HStack(spacing: 10) {
                        Image(ImageName.dwMarker)
                            .resizable()
                            .frame(width: 40, height: 60)
                        Image(ImageName.dwClear)
                            .resizable()
                            .frame(width: 40, height: 60)
                            .wrapToButton {
                                canvasView.drawing = PKDrawing()
                            }
                        Image(ImageName.dwUndo)
                            .resizable()
                            .frame(width: 40, height: 60)
                            .wrapToButton {
                                undoManager?.undo()
                            }
                        Image(ImageName.dwRedo)
                            .resizable()
                            .frame(width: 40, height: 60)
                            .wrapToButton {
                                undoManager?.redo()
                            }
                    }
                    Text("저장")
                        .asfullCapsuleButton(background: .accent)
                        .wrapToButton {
                            saveDrawing()
                            presentationMode.wrappedValue.dismiss()
                        }
                        .padding()
                }
            } else {
                CameraView(cameraService: cameraService, cameraSize: (cameraSize, cameraSize)) { result in
                    switch result{
                    case .success(let photo):
                        if let data = photo.fileDataRepresentation(){
                            capturedImage = UIImage(data : data)
                            canvasView.backgroundColor = .clear
                            //presentationMode.wrappedValue.dismiss()
                            
                        }else{
                            print("Error : no image data found")
                        }
                    case .failure(let err):
                        print(err.localizedDescription)
                    }
                }
                .frame(width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.width - 40)
                
                
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
    
    
    private func saveDrawing() {
        let targetSize = CGSize(width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.width - 40)
        
        let imageOriginX = (canvasView.bounds.width - targetSize.width) / 2
        let imageOriginY = (canvasView.bounds.height - targetSize.height) / 2
        let drawingRect = CGRect(origin: CGPoint(x: -imageOriginX, y: -imageOriginY), size: canvasView.bounds.size)

        let renderer = UIGraphicsImageRenderer(size: targetSize)

        let combinedImage = renderer.image { context in
            capturedImage?.draw(in: drawingRect)
            
            let drawingImage = canvasView.drawing.image(from: canvasView.bounds, scale: UIScreen.main.scale)
            drawingImage.draw(in: drawingRect)
        }

        imageWithPen = combinedImage
    }
}

// 버튼 뒤에 나오는 실시간 화면

struct CameraView : UIViewControllerRepresentable {

    typealias UIViewControllerType = UIViewController
    
    // 카메라 보기 외부에서 캡처 사진에 엑세스하기를 원하기 때문에 카메라 서비스를 초기화해줘야함
    // 그래야 버튼등을 내가 원하는대로 커스텀할 수 있다.
    let cameraService : CameraService
    let cameraSize: (CGFloat, CGFloat)
    
    // 결과값이 오류가 나올 수도 있기에 이렇게 설정
    let didFinishProcessingPhoto: (Result<AVCapturePhoto, Error>) -> ()
    
    //UIView를 만듬
    func makeUIViewController(context: Context) -> UIViewController {
        cameraService.start(delegate: context.coordinator){ err in
            if let err = err {
                didFinishProcessingPhoto(.failure(err))
                return
            }
        }
        
        let viewController = UIViewController()
        
        viewController.view.backgroundColor = .black
        viewController.view.layer.addSublayer(cameraService.previewLayer)
        
        cameraService.previewLayer.frame = CGRect(x: 0, y: 0, width: cameraSize.0, height: cameraSize.1)
        return viewController
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, didFinishProcessingPhoto: didFinishProcessingPhoto)
    }
    
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {

    }
    
    // 실제로 원하는 대리자를 준수하게 된다.
    class Coordinator : NSObject,AVCapturePhotoCaptureDelegate {
        
        // 부모 뷰를 추가
        let parent : CameraView
        private var didFinishProcessingPhoto: (Result<AVCapturePhoto, Error>) -> ()
        
        // 부모 뷰를 위한 초기화
        // @escaping을 사용하는 이유는 함수가 끝나고도 사용을 원할때 ex) 스크린샷을 찍고 잠깐 남아있는 경우가 그 예시
        init(_ parent: CameraView, didFinishProcessingPhoto: @escaping (Result<AVCapturePhoto, Error>) -> ()){
            self.parent = parent
            self.didFinishProcessingPhoto = didFinishProcessingPhoto
        }
        
        
        func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?){
            if let error = error {
                didFinishProcessingPhoto(.failure(error))
                return
            }
            didFinishProcessingPhoto(.success(photo))
            
        }
        
        
    }
    
}

