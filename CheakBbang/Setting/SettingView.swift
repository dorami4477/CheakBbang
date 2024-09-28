//
//  SettingView.swift
//  CheakBbang
//
//  Created by 박다현 on 9/28/24.
//

import SwiftUI
import RealmSwift

struct SettingView: View {
    @StateObject var viewModel: SettingViewModel
    
    var body: some View {
        GIFView(gifName: ImageName.cat01, width: 110)
            .frame(width: 110, height: 73)
        let nickName = UserDefaults.standard.string(forKey: "nickName")
        Text(nickName ?? "")
        Text("\(viewModel.output.bookCount)")
        Text("\(viewModel.output.totalPage)")
        Text("\(viewModel.output.MemoCount)")
        Text("\(viewModel.output.version)")
    }
}
