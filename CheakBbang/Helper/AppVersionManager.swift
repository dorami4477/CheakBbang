//
//  AppVersionManager.swift
//  CheakBbang
//
//  Created by 박다현 on 10/4/24.
//

import Foundation

final class AppVersionManager {
    
    static let shared = AppVersionManager()
    private init() {}
    
    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.00"
    
    func latestVersion(completion: @escaping (String?) -> Void) {
        guard
            let bundleIdentifier = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String,
            let url = URL(string: "https://itunes.apple.com/lookup?bundleId=\(bundleIdentifier)") else {
                completion(nil)
                return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data,
                  error == nil,
                  let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                  let results = json["results"] as? [[String: Any]],
                  let appStoreVersion = results.first?["version"] as? String else {
                completion(nil)
                return
            }
            completion(appStoreVersion)
        }.resume()
    }

    func shouldUpdate() -> Bool {
        var storeVersion: String? = nil
        latestVersion { version in
            storeVersion = version
        }
        
        guard
            let nowVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
            let storeVersion = storeVersion
        else { return false }
        
        let nowVersionArr = nowVersion.split(separator: ".").map { $0 }
        let storeVersionArr = storeVersion.split(separator: ".").map { $0 }
        
        print(nowVersionArr)
        print(storeVersionArr)
        
        if nowVersionArr[0] < storeVersionArr[0] || nowVersionArr[1] < storeVersionArr[1] {
            return true
        }
        
        return false
    }
}
