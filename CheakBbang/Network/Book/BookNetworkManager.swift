//
//  BookNetworkManager.swift
//  CheakBbang
//
//  Created by 박다현 on 9/11/24.
//

import Combine
import Foundation

import Alamofire

final class BookNetworkManager: NetworkRequestConvertible {
    typealias api = BookRouter
    
    func fetchBookList(_ search: String, index: Int) -> AnyPublisher<Result<BookDTO, NetworkError>, Never> {
        Future { promise in
            Task { [weak self] in
                do {
                    guard let self else { return }
                    let value = try await self.callRequest(api: .list(query: search, index: index), model: BookDTO.self)
                    promise(.success(.success(value)))
                    
                } catch {
                    guard let self else { return }
                    promise(.success(.failure(self.networkErrorHandling(error: error))))
                    print(error.localizedDescription)
                    
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func fetchSingleBookItem(_ isbn: String) -> AnyPublisher<ItemDTO, NetworkError> {
        Future { promise in
            Task { [weak self] in
                do {
                    let value = try await self?.callRequest(api: .item(id: isbn), model: BookDTO.self)
                    if let item = value?.item.first {
                        promise(.success(item))
                    } else {
                        promise(.failure(NetworkError.unknownError))
                    }
                } catch {
                    if let afError = error as? Alamofire.AFError {
                        print("Alamofire 에러: \(afError.localizedDescription)")
                        
                        if case let .sessionTaskFailed(underlyingError) = afError {
                            let nsError = underlyingError as NSError
                            
                            if nsError.domain == NSURLErrorDomain {
                                switch nsError.code {
                                case NSURLErrorNotConnectedToInternet:
                                    promise(.failure(.notConnectedToInternet))
                                    
                                case NSURLErrorTimedOut:
                                    promise(.failure(.timedOut))
                                    
                                case NSURLErrorCannotFindHost:
                                    promise(.failure(.cannotFindHost))
                                    
                                case NSURLErrorNetworkConnectionLost:
                                    promise(.failure(.networkConnectionLost))
                                    
                                default:
                                    print("기타 네트워크 에러: \(nsError.localizedDescription)")
                                    promise(.failure(.unknownError))
                                }
                            }
                        } else {
                            promise(.failure(.unknownError))
                        }
                        
                    } else {
                        print("알 수 없는 에러: \(error.localizedDescription)")
                        promise(.failure(.unknownError))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
