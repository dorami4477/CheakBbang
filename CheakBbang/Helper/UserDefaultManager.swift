//
//  UserDefaultManager.swift
//  CheakBbang
//
//  Created by 박다현 on 9/28/24.
//

import Foundation

@propertyWrapper
struct UserDefault<T>{
    
    let key:String
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
    static var nickName:String
    
    static func deleteAllData() {
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            UserDefaults.standard.removeObject(forKey: key.description)
        }
    }
}
