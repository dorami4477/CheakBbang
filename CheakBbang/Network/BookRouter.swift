//
//  BookRouter.swift
//  CheakBbang
//
//  Created by 박다현 on 9/10/24.
//

import Foundation
import Alamofire

enum BookRouter {
    case list(query: String)
    case item(id: Int)
}

extension BookRouter: TargetType {

    var baseURL: String {
        return APIKey.baseUrl
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
        case .list(let query):
            return [
                URLQueryItem(name: "ttbkey", value: APIKey.key),
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "QueryType", value: "Title"),
                URLQueryItem(name: "MaxResults", value: "10"),
                URLQueryItem(name: "start", value: "1"),
                URLQueryItem(name: "SearchTarget", value: "Book"),
                URLQueryItem(name: "output", value: "JS"),
                URLQueryItem(name: "Version", value: "20131101")
            ]
        case .item(let id):
            return [
                URLQueryItem(name: "ttbkey", value: APIKey.key),
                URLQueryItem(name: "itemIdType", value: "ISBN"),
                URLQueryItem(name: "ItemId", value: "\(id)"),
                URLQueryItem(name: "output", value: "JS"),
                URLQueryItem(name: "Version", value: "20131101")
            ]
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}
