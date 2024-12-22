//
//  RegisterBookView.swift
//  CheakBbang
//
//  Created by 박다현 on 12/21/24.
//

import SwiftUI
import Combine
import PhotosUI

struct RegisterBookView: View {
    @StateObject var viewModel: RegisterBookViewModel
    @State var cancellables = Set<AnyCancellable>()
    @State private var isCustomCameraViewPresented: Bool = false
    @State private var bookCover: UIImage? = nil
    @State private var selectedItem: PhotosPickerItem?
    
    var body: some View {
        ScrollView {
            if let bookCover {
                Image(uiImage: bookCover)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100)
            }
            
            HStack {
                Button {
                    isCustomCameraViewPresented.toggle()
                } label: {
                    Image("icon_camera")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                }
                .sheet(isPresented: $isCustomCameraViewPresented, content: {
                    BookCameraView(capturedImage: $bookCover)
                })
                
                PhotosPicker(
                    selection: $selectedItem,
                    matching: .images
                ) {
                    Image("icon_gallery")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                }
                .onChange(of: selectedItem) { newItem in
                    Task {
                        guard let newItem = newItem else { return }
                        do {
                            if let imageData = try await newItem.loadTransferable(type: Data.self) {
                                bookCover = UIImage(data: imageData)
                            }
                        } catch {
                            print("Error loading image: \(error)")
                        }
                    }
                }
            }
        }
        .toolbar {
            
        }
        
    }
}
