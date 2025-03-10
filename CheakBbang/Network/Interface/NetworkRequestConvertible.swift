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
    func callRequest(api: api, etagKey: String? = nil) async throws -> Data {
        let config = URLSessionConfiguration.default
        if etagKey != nil {
            config.requestCachePolicy = .reloadIgnoringLocalCacheData
        }
        let session = Session(configuration: config)
        let request = try api.asURLRequest()
        
        return try await withCheckedThrowingContinuation { continuation in
            session.request(request).responseData { response in
                switch response.result {
                case let .success(data):
                    if let httpResponse = response.response,
                       let etag = httpResponse.allHeaderFields["Etag"] as? String,
                       let etagKey {
                        UserDefaultsManager.eTags[etagKey] = etag
                    }
                    continuation.resume(returning: data)
                    
                case let .failure(error):
                    if let statusCode = response.response?.statusCode, statusCode == 304 {
                        continuation.resume(throwing: NetworkError.hasNotChanged)
                    } else {
                        continuation.resume(throwing: error)
                    }
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
                        return .unknownError(error: nsError.localizedDescription)
                    }
                }
                
            } else {
                return .unknownError(error: afError.localizedDescription)
            }
        }
        return .unknownError(error: error.localizedDescription)
    }
}
