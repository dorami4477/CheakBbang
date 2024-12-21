//
//  RegisterBookView.swift
//  CheakBbang
//
//  Created by 박다현 on 12/21/24.
//

import SwiftUI
import Combine

struct RegisterBookView: View {
    @StateObject var viewModel: RegisterBookViewModel
    @State var cancellables = Set<AnyCancellable>()
    @State private var isCustomCameraViewPresented: Bool = false
    @State private var bookCover: UIImage? = nil
    
    var body: some View {
        ScrollView {
            if let bookCover {
                Image(uiImage: bookCover)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200)
            }
            
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
        }
        .toolbar {
            
        }
        
    }
}
