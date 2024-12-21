//
//  MemoListWrapper.swift
//  CheakBbang
//
//  Created by 박다현 on 9/26/24.
//

import SwiftUI

struct MemoListWrapper: View {
    var body: some View {
        MemoList(viewModel: MemoListViewModel(repository: MyMemoRepository()))
            .navigationTitle("메모 서랍")
            .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    MemoListWrapper()
}
