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
    
    @Binding var imageWithPen : Image?
    @Binding var pickerImage : UIImage?
    @State private var canvasView = PKCanvasView()
    
    var body: some View{
        VStack{
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
            }
        }
        .onAppear{
            canvasView.backgroundColor = .clear
        }
    }
    
    private func saveDrawing() {
        let renderer = UIGraphicsImageRenderer(size: canvasView.bounds.size)

        let combinedImage = renderer.image { context in
            pickerImage?.draw(in: canvasView.bounds)

            let drawingImage = canvasView.drawing.image(from: canvasView.bounds, scale: UIScreen.main.scale)
            drawingImage.draw(in: canvasView.bounds)
        }

        imageWithPen = Image(uiImage: combinedImage)
    }
}

