//
//  AddMemoView.swift
//  CheakBbang
//
//  Created by 박다현 on 9/19/24.
//

import SwiftUI
import PhotosUI

struct AddMemoView: View {    
    @StateObject var viewModel = AddMemoViewModel()
    @Environment(\.dismiss) private var dismiss
    
    @State private var showAlert = false
    @State private var isCustomCameraViewPresented = false
    @State private var isDrawingViewPresented = false
    
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var image: UIImage? = nil
    @State private var pickerImage: UIImage? = nil
    
    @State var item: MyBook
    @State var memo: Memo?
    
    @State private var page: String = ""
    @State private var content: String = ""
    
    var isEditing: Bool {
        return memo != nil
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                HStack(alignment: .top) {
                    Text("내용*")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(Color.black)
                        .frame(maxWidth: 70, alignment: .leading)
                    
                    ZStack(alignment: .topLeading) {
                        TextEditor(text: $content)
                            .background(Color.white)
                            .frame(height: 150)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.accent, lineWidth: 2)
                                    .frame(height: 150)
                            }
                            .onAppear {
                                if let memo {
                                    content = memo.contents
                                }
                            }
                    }
                }
                
                HStack(alignment: .top) {
                    Text("페이지")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(Color.black)
                        .frame(maxWidth: 70, alignment: .leading)
                    
                    TextField("", text: $page)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 2)
                        )
                        .frame(width: 80)
                        .onAppear {
                            if let memo {
                                page = memo.page
                            }
                        }
                    
                    Text("전체 책에 대한 메모라면, 비워주세요!")
                        .foregroundColor(.gray)
                        .font(.system(size: 14))
                }
                
                HStack(alignment: .top) {
                    Text("사진")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(Color.black)
                        .frame(maxWidth: 70, alignment: .leading)
                    
                    HStack(alignment: .top, spacing: 5) {
                        if let image {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 200, height: 200)
                                .clipped()
                                .cornerRadius(10)
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
                            CustomCameraView(imageWithPen: $image)
                        })
                        
                        PhotosPicker(
                            selection: $selectedPhoto,
                            matching: .images
                        ) {
                            Image("icon_gallery")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 32, height: 32)
                        }
                        .onChange(of: selectedPhoto) { newItem in
                            Task {
                                guard let newItem = newItem else { return }
                                do {
                                    //image = try await newItem.loadTransferable(type: Image.self)
                                    if let imageData = try await newItem.loadTransferable(type: Data.self) {
                                        pickerImage = UIImage(data: imageData)
                                        isDrawingViewPresented = true
                                    }
                                } catch {
                                    print("Error loading image: \(error)")
                                }
                            }
                        }
                        .sheet(isPresented: $isDrawingViewPresented, content: {
                            DrawingView(imageWithPen: $image, pickerImage: $pickerImage)
                        })
                        
                        
                    }
                }
                .onAppear {
                    loadImageFromFile()
                }
                
                Text(isEditing ? "수정" : "저장")
                    .asfullCapsuleButton()
                    .wrapToButton {
                        let newMemo = Memo(bookId: item.id, page: page, contents: content, date: Date())
                        
                        if isEditing {
                            viewModel.action(.editButtonTap(memo: newMemo, image: image))
                        } else {
                            viewModel.action(.addButtonTap(memo: newMemo, image: image))
                        }
                        
                        dismiss()
                    }
                    .disabled(content.isEmpty)
                
                Spacer()
                
            }
            .padding()
        }
            .onTapGesture(perform: {
                UIApplication.shared.endEditing()
            })
            .navigationTitle("메모")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear{
                viewModel.action(.viewOnAppear(item: item, memo: memo ?? Memo()))
            }
            .toolbar {
                if isEditing {
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        Image(ImageName.trash)
                            .resizable()
                            .frame(width: 24, height: 24)
                            .wrapToButton {
                                showAlert = true
                            }
                            .alert("정말 삭제 하시겠습니까?", isPresented: $showAlert) {
                                Button("삭제") {
                                    viewModel.action(.deleteButtonTap)
                                    dismiss()
                                }
                                Button("취소", role: .cancel) {}
                            }
                    }
                }
            }
    }
    
    
    @MainActor
    func loadImageFromFile() {
        if let memo, let url = PhotoFileManager.shared.loadFileURL(filename: "\(memo.id)") {
            do {
                let data = try Data(contentsOf: url)
                self.image = UIImage(data: data)
            } catch {
                print("Error loading image from URL: \(error)")
            }
        }
    }

}

