//
//  BookRouter.swift
//  CheakBbang
//
//  Created by 박다현 on 9/10/24.
//

import Foundation
import Alamofire

enum BookRouter {
    case list(query: String, index:Int)
    case item(id: String)
}

extension BookRouter: TargetType {

    var baseURL: String {
        return APIKeys.baseUrl
    }
    
    var path: String {
        switch self {
        case .list:
            return "/ItemSearch.aspx"
        case .item:
            return "/ItemLookUp.aspx"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        return .get
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .list(let query, let index):
            return [
                URLQueryItem(name: "ttbkey", value: APIKeys.key),
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "MaxResults", value: "35"),
                URLQueryItem(name: "Cover", value: "MidBig"),
                URLQueryItem(name: "start", value: "\(index)"),
                URLQueryItem(name: "SearchTarget", value: "Book"),
                URLQueryItem(name: "output", value: "JS"),
                URLQueryItem(name: "Version", value: "20131101")
                
            ]
        case .item(let id):
            return [
                URLQueryItem(name: "ttbkey", value: APIKeys.key),
                URLQueryItem(name: "itemIdType", value: "ISBN"),
                URLQueryItem(name: "Cover", value: "Big"),
                URLQueryItem(name: "ItemId", value: id),
                URLQueryItem(name: "output", value: "JS"),
                URLQueryItem(name: "Version", value: "20131101")
                
            ]
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}
