//
//  BookNetworkManager.swift
//  CheakBbang
//
//  Created by 박다현 on 9/11/24.
//

import Combine
import Foundation

final class BookNetworkManager: DecodableNetworkRequestConvertible {
    typealias DecodableType = BookDTO
    typealias api = BookRouter
    
    func fetchBookList(_ search: String, index: Int) -> AnyPublisher<Result<BookDTO, NetworkError>, Never> {
        Future { promise in
            Task { [weak self] in
                guard let self else { return }
                
                do {
                    let rawData = try await self.callRequest(api: .list(query: search, index: index))
                    let decodedData = try decodeResponse(data: rawData)
                    
                    promise(.success(.success(decodedData)))
                    
                } catch {
                    promise(.success(.failure(self.networkErrorHandling(error: error))))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func fetchSingleBookItem(_ isbn: String) -> AnyPublisher<ItemDTO, NetworkError> {
        Future { promise in
            Task { [weak self] in
                guard let self else { return }
                
                do {
                    let rawData = try await self.callRequest(api: .item(id: isbn))
                    let decodedData = try decodeResponse(data: rawData)
                    
                    if let item = decodedData.item.first {
                        promise(.success(item))
                    } else {
                        promise(.failure(NetworkError.noItem))
                    }
                } catch {
                    promise(.failure(self.networkErrorHandling(error: error)))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
