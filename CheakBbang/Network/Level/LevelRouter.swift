//
//  LevelRouter.swift
//  CheakBbang
//
//  Created by 박다현 on 2/14/25.
//

import Foundation

import Alamofire

enum LevelRouter {
    case level
    case toyImage(filename: String)
}

extension LevelRouter: TargetType {
    var baseURL: String {
        return APIKeys.itemBaseUrl
    }
    
    var path: String {
        switch self {
        case .level:
            return "/etag_JSON.php"
        case .toyImage(let filename):
            return filename
        }
    }
    
    var method: Alamofire.HTTPMethod {
        return .get
    }
    
    var queryItems: [URLQueryItem] {
        return []
    }
    
    var headers: [String : String]? {
        var etag = String()
        
        switch self {
        case .level:
            etag = UserDefaultsManager.eTags["levelEtag"] ?? ""
        case .toyImage(let filename):
            etag = UserDefaultsManager.eTags[filename] ?? ""
        }
        
        return ["If-None-Match": etag]
    }
}
