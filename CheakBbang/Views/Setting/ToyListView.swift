//
//  ToyListView.swift
//  CheakBbang
//
//  Created by 박다현 on 2/14/25.
//

import SwiftUI

struct ToyListView: View {
    let levelList: [LevelModel]
    let level = UserDefaultsManager.level
    let toyImages: [Data?]
    
    var body: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ]) {
            ForEach(0...levelList.count, id: \.self) { index in
                if index < level && index < toyImages.count {
                        let data = levelList[index]
                        
                        VStack {
                            if let toyData = toyImages[index], let toyImage = UIImage(data: toyData) {
                                Image(uiImage: toyImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: UIScreen.main.bounds.width * 0.3, height: UIScreen.main.bounds.width * 0.15)

                            } else {
                                Image(ImageName.toyListNext)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: UIScreen.main.bounds.width * 0.3, height: UIScreen.main.bounds.width * 0.15)
                            }
                            
                            Text("Lv \(data.level)")
                                .font(.system(size: 12))
                                .foregroundStyle(.accent)
                            
                            Text("\(data.name)")
                                .font(.system(size: 14))
                                .foregroundStyle(.gray)
                                .multilineTextAlignment(.center)
                        }
                    
                    } else if index == levelList.count {
                        VStack {
                            Image(ImageName.toyListNext)
                                .resizable()
                                .scaledToFit()
                                .frame(width: UIScreen.main.bounds.width * 0.3, height: UIScreen.main.bounds.width * 0.15)
                            
                            Text("Lv \(level + 1)")
                                .font(.system(size: 12))
                                .foregroundStyle(.accent)
                            
                            Text("???")
                                .font(.system(size: 14))
                                .foregroundStyle(.gray)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
}
