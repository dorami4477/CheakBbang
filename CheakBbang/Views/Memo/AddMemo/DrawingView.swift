//
//  DrawingView.swift
//  CheakBbang
//
//  Created by 박다현 on 9/22/24.
//

import SwiftUI
import PhotosUI
import PencilKit

struct DrawingView: View {
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.undoManager) private var undoManager
    
    @Binding var imageWithPen : UIImage?
    @Binding var pickerImage : UIImage?
    @State private var canvasView = PKCanvasView()
    
    var body: some View{
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack {
                if let image = pickerImage {
                    Text("마음에 드는 글귀에 밑줄을 그어주세요.")
                        .foregroundStyle(.gray)
                        .font(.system(size: 14))
                    
                    ZStack {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                        
                        MyCanvas(canvasView: $canvasView, backgroundImage: pickerImage)
                        
                    }
                    .frame(width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.width - 40)
                    .clipped()
                }
                
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
            }
        }
        .onAppear{
            canvasView.backgroundColor = .clear
        }
    }
    private func saveDrawing() {
        let targetSize = CGSize(width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.width - 40)
        
        let imageOriginX = (canvasView.bounds.width - targetSize.width) / 2
        let imageOriginY = (canvasView.bounds.height - targetSize.height) / 2
        let drawingRect = CGRect(origin: CGPoint(x: -imageOriginX, y: -imageOriginY), size: canvasView.bounds.size)

        let renderer = UIGraphicsImageRenderer(size: targetSize)

        let combinedImage = renderer.image { context in
            pickerImage?.draw(in: drawingRect)
            
            let drawingImage = canvasView.drawing.image(from: canvasView.bounds, scale: UIScreen.main.scale)
            drawingImage.draw(in: drawingRect)
        }

        imageWithPen = combinedImage
    }
}

