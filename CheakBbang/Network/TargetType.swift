//
//  TargetType.swift
//  CheakBbang
//
//  Created by 박다현 on 9/11/24.
//

import Foundation
import Alamofire

protocol TargetType: URLRequestConvertible {
    var baseURL: String { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
}

extension TargetType {
    
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL()
        var request = try URLRequest(url: url.appendingPathComponent(path), method: method)
        request.url?.append(queryItems: queryItems)
        return request
    }
    
}
