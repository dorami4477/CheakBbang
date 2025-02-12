//
//  ContentViewModel.swift
//  CheakBbang
//
//  Created by 박다현 on 9/27/24.
//

import Foundation

import FirebaseRemoteConfig

class ContentViewModel: ObservableObject {
    @Published var newsUrl: String = ""
    @Published var hasNews = false
    @Published var newsNum = 1
     var remoteConfig = RemoteConfig.remoteConfig()
     var settings = RemoteConfigSettings()
     
     init() {
       //self.newsUrl = newsUrl
       setupRemoteConfigListener()
       Task {
         await activateRemoteConfig()
       }
     }
    
     // MARK: - RemoteConfig 리스너 설정
     func setupRemoteConfigListener() {
       self.settings.minimumFetchInterval = 0
       self.remoteConfig.configSettings = settings
       remoteConfig.addOnConfigUpdateListener { configUpdate, error in
         if let error {
           print("Error: \(error)")
           return
         }
         Task {
           await self.activateRemoteConfig()
         }
       }
     }
     
     // MARK: - RemoteConfig 활성화
    @MainActor
    private func activateRemoteConfig() async {
        do {
            try await remoteConfig.fetch()
            try await remoteConfig.activate()
            
            let isNeedUpdate = remoteConfig["hasNews"].boolValue
            
            if isNeedUpdate {
                self.newsNum = remoteConfig.configValue(forKey: "newsNum").numberValue.intValue
                self.newsUrl = remoteConfig["newsContents"].stringValue
            } else {
                self.newsUrl = ""
            }
            
            if isNeedUpdate && !UserDefaultsManager.hasSeenPopup && UserDefaultsManager.newsNum == newsNum {
                hasNews = isNeedUpdate
            }
            
        } catch {
            print("Error: \(error)")
        }
    }
}
