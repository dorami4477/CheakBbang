//
//  NetworkManager.swift
//  CheakBbang
//
//  Created by 박다현 on 9/11/24.
//

import Foundation
import Alamofire

enum ErrorCode:Error{
    case BadRequest
    case Unauthorized
    case Forbidden
    case NotFound
    case serverError
    case NetworError
}

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    func callRequest<T: Decodable>(api:BookRouter, model:T.Type) async throws -> T {
        
        let request = try api.asURLRequest()
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(request).responseDecodable(of: model) { response in
                switch response.result {
                case let .success(data):
                    continuation.resume(returning: data)
                    
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
