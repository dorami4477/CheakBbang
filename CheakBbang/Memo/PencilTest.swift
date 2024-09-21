//
//  PencilTest.swift
//  CheakBbang
//
//  Created by 박다현 on 9/21/24.
//

import SwiftUI
import PencilKit
import PhotosUI

struct Writer: View {
    @Environment(\.undoManager) private var undoManager
    @State private var canvasView = PKCanvasView()
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var backgroundImage: UIImage?

    var body: some View {
        VStack(spacing: 10) {
            PhotosPicker(
                selection: $selectedPhoto,
                matching: .images
            ) {
                Text("Select Image")
            }
            .onChange(of: selectedPhoto) { newPhoto in
                Task {
                    if let data = try? await newPhoto?.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        backgroundImage = image
                        canvasView.backgroundColor = .clear
                    }
                }
            }
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
                }
            }
            if let image = backgroundImage {
                ZStack {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()

                    MyCanvas(canvasView: $canvasView, backgroundImage: backgroundImage)
                        .overlay(
                            Rectangle()
                                .fill(Color.clear) // 터치 이벤트를 위한 투명한 오버레이
                        )
                }
            } else {
                Text("이미지를 선택하세요.")
                    .padding()
            }
            
        }
    }

    private func saveDrawing() {
        let renderer = UIGraphicsImageRenderer(size: canvasView.bounds.size)

        let combinedImage = renderer.image { context in
            // 배경 이미지 그리기
            backgroundImage?.draw(in: canvasView.bounds)

            // 캔버스의 드로잉을 UIImage로 변환 후 그리기
            let drawingImage = canvasView.drawing.image(from: canvasView.bounds, scale: UIScreen.main.scale)
            drawingImage.draw(in: canvasView.bounds)
        }

        // 이미지를 카메라 롤에 저장
        UIImageWriteToSavedPhotosAlbum(combinedImage, nil, nil, nil)
    }
}





struct MyCanvas: UIViewRepresentable {
    @Binding var canvasView: PKCanvasView
    var backgroundImage: UIImage?

    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.drawingPolicy = .anyInput
        canvasView.tool = PKInkingTool(.marker, color: .accent.withAlphaComponent(0.4), width: 22)
        return canvasView
    }

    func updateUIView(_ canvasView: PKCanvasView, context: Context) {
        // 배경 이미지를 그립니다.
        if let image = backgroundImage {
            let imageView = UIImageView(image: image)
            imageView.frame = canvasView.bounds
            canvasView.addSubview(imageView)
            canvasView.sendSubviewToBack(imageView) // 배경으로 설정
        }
    }
}
