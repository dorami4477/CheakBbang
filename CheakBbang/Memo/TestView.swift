//
//  TestView.swift
//  CheakBbang
//
//  Created by 박다현 on 9/20/24.
//

import SwiftUI
import PhotosUI

struct TestView: View {
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var image: Image?
    
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
        }
    }
}
