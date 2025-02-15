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
}

extension LevelRouter: TargetType {
    var baseURL: String {
        return APIKeys.itemBaseUrl
    }
    
    var path: String {
        return "/toy_list.json"
    }
    
    var method: Alamofire.HTTPMethod {
        return .get
    }
    
    var queryItems: [URLQueryItem] {
        return []
    }
    
    var headers: [String : String]? {
        return nil
    }
}
