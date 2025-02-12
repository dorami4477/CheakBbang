//
//  OnboardingViewModel.swift
//  CheakBbang
//
//  Created by 박다현 on 2/12/25.
//

import Foundation

class OnboardingViewModel: ObservableObject {
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
