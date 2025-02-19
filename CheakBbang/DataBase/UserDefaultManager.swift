//
//  UserDefaultManager.swift
//  CheakBbang
//
//  Created by 박다현 on 9/28/24.
//

import Foundation

@propertyWrapper
struct UserDefault<T>{
    
    let key: String
    let defaultValue: T
    
    var wrappedValue: T{
        get{UserDefaults.standard.object(forKey: key) as? T ?? self.defaultValue }
        set{UserDefaults.standard.setValue(newValue, forKey: key)}
    }
    
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
}

enum UserDefaultsManager{
    
    @UserDefault(key: "nickName", defaultValue: "")
    static var nickName: String
    
    @UserDefault(key: "level", defaultValue: 1)
    static var level: Int
    
    @UserDefault(key: "bookCount", defaultValue: 0)
    static var bookCount: Int
    
    @UserDefault(key: "hasSeenPopup", defaultValue: false)
    static var hasSeenPopup: Bool
    
    @UserDefault(key: "newsNum", defaultValue: 1)
    static var newsNum: Int
    
    @UserDefault(key: "eTags", defaultValue: [String: String]())
    static var eTags: [String: String]
    
    static func deleteAllData() {
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            UserDefaults.standard.removeObject(forKey: key.description)
        }
    }
}
