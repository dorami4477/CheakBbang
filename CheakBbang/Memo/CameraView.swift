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
    @Binding var imageWithPen : Image?
    @State var capturedImage : UIImage?
    @Environment(\.presentationMode) private var presentationMode
    
    @Environment(\.undoManager) private var undoManager
    @State private var canvasView = PKCanvasView()
    
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
                
                HStack {
                    Button("Clear") {
                        canvasView.drawing = PKDrawing()
                    }
                    Button("Undo") {
                        undoManager?.undo()
                    }
                    Button("Redo") {
                        undoManager?.redo()
                    }
                    Button("Save Drawing") {
                        saveDrawing()
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            } else {
                CameraView(cameraService: cameraService) { result in
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
        let renderer = UIGraphicsImageRenderer(size: canvasView.bounds.size)

        let combinedImage = renderer.image { context in
            capturedImage?.draw(in: canvasView.bounds)

            let drawingImage = canvasView.drawing.image(from: canvasView.bounds, scale: UIScreen.main.scale)
            drawingImage.draw(in: canvasView.bounds)
        }

        imageWithPen = Image(uiImage: combinedImage)
       //UIImageWriteToSavedPhotosAlbum(combinedImage, nil, nil, nil)
    }
}

// 버튼 뒤에 나오는 실시간 화면

struct CameraView : UIViewControllerRepresentable {

    typealias UIViewControllerType = UIViewController
    
    // 카메라 보기 외부에서 캡처 사진에 엑세스하기를 원하기 때문에 카메라 서비스를 초기화해줘야함
    // 그래야 버튼등을 내가 원하는대로 커스텀할 수 있다.
    let cameraService : CameraService
    
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
        
        // ViewController 선언
        let viewController = UIViewController()
        
        viewController.view.backgroundColor = .black
        viewController.view.layer.addSublayer(cameraService.previewLayer)
        // 이전에 클래스에 선언해둔 previewLayer
        //cameraService.previewLayer.frame = viewController.view.bounds
        cameraService.previewLayer.frame = CGRect(x: 0, y: 0, width: viewController.view.bounds.width - 40, height: viewController.view.bounds.width - 40)
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

