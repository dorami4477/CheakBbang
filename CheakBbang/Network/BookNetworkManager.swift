//
//  BookNetworkManager.swift
//  CheakBbang
//
//  Created by 박다현 on 9/11/24.
//

import Combine
import Foundation

import Alamofire

enum BookNetworkError: Error {
    case notConnectedToInternet
    case timedOut
    case cannotFindHost
    case networkConnectionLost
    case unknownError
}

final class BookNetworkManager: NetworkRequestConvertible {
    typealias api = BookRouter
    
    func fetchLevel() -> AnyPublisher<Result<[LevelDTO], BookNetworkError>, Never> {
        Future { promise in
            Task { [weak self] in
                do {
                    guard let self else { return }
                    let value = try await self.callRequest(api: .level, model: [LevelDTO].self)
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
    
    func fetchBookList(_ search: String, index: Int) -> AnyPublisher<Result<BookDTO, BookNetworkError>, Never> {
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
    
    func fetchSingleBookItem(_ isbn: String) -> AnyPublisher<ItemDTO, BookNetworkError> {
        Future { promise in
            Task { [weak self] in
                do {
                    let value = try await self?.callRequest(api: .item(id: isbn), model: BookDTO.self)
                    if let item = value?.item.first {
                        promise(.success(item))
                    } else {
                        promise(.failure(BookNetworkError.unknownError))
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
    
    func networkErrorHandling(error: Error) -> BookNetworkError {
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
