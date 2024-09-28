//
//  ContentViewModel.swift
//  CheakBbang
//
//  Created by 박다현 on 9/27/24.
//

import Foundation

class ContentViewModel: ObservableObject {
    @Published var isFirstRun = false
    
    init() {
        self.checkFirstRun()
    }
    
    func checkFirstRun() {
        let nickname = UserDefaults.standard.string(forKey: "nickName")
        isFirstRun = nickname == nil || nickname?.isEmpty == true
    }
    
    func saveNickname(_ nickname: String) {
           UserDefaults.standard.set(nickname, forKey: "nickName")
       }

}
