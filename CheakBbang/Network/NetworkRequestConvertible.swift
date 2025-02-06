//
//  NetworkRequestConvertible.swift
//  CheakBbang
//
//  Created by 박다현 on 2/5/25.
//

import Foundation

import Alamofire

protocol NetworkRequestConvertible {
    associatedtype api: TargetType
}

extension NetworkRequestConvertible {
    func callRequest<Model: Decodable>(api: api, model:Model.Type) async throws -> Model {
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
