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
    
    func networkErrorHandling(error: Error) -> NetworkError {
        if let afError = error as? Alamofire.AFError {
            print("Alamofire 에러: \(afError.localizedDescription)")
            
            if case let .sessionTaskFailed(underlyingError) = afError {
                let nsError = underlyingError as NSError
                
                if nsError.domain == NSURLErrorDomain {
                    switch nsError.code {
                    case NSURLErrorNotConnectedToInternet:
                        return .notConnectedToInternet
                        
                    case NSURLErrorTimedOut:
                        return .timedOut
                        
                    case NSURLErrorCannotFindHost:
                        return .cannotFindHost
                        
                    case NSURLErrorNetworkConnectionLost:
                        return .networkConnectionLost
                        
                    default:
                        return .unknownError
                    }
                }
                
            } else {
                return .unknownError
            }
        }
        return .unknownError
    }
}
