//
//  BookRouter.swift
//  CheakBbang
//
//  Created by 박다현 on 9/10/24.
//

import Foundation
import Moya

enum BookRouter {
    case list(query: String)
    case item(id: Int)
}

extension BookRouter: TargetType {
    var baseURL: URL {
        return URL(string: APIKey.baseUrl)!
    }
    
    var path: String {
        switch self {
        case .list:
            return "/ItemSearch.aspx"
        case .item:
            return "/ItemLookUp.aspx"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Moya.Task {
        var parameters: [String: Any] = [:]
        switch self {
        case .list(let query):
            parameters = [
                "ttbkey": APIKey.key,
                "query": query,
                "QueryType": "Title",
                "MaxResults": "10",
                "start": 1,
                "SearchTarget": "Book",
                "output": "JS",
                "Version": "20131101",
            ]
        case .item(let id):
            parameters = [
                "ttbkey": APIKey.key,
                "itemIdType": "ISBN",
                "ItemId": id,
                "output": "JS",
                "Version": "20131101",
            ]
        }
        return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
    }
    
    var headers: [String : String]? {
        return nil
    }
}
