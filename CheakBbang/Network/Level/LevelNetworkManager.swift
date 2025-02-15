//
//  LevelNetworkManager.swift
//  CheakBbang
//
//  Created by 박다현 on 2/14/25.
//

import Combine
import Foundation

import Alamofire

final class LevelNetworkManager: NetworkRequestConvertible {
    typealias api = LevelRouter
    
    func fetchLevel() async throws -> [LevelDTO] {
        do {
            let value = try await self.callRequest(api: .level, model: [LevelDTO].self)
            
            return value
        } catch {
            throw networkErrorHandling(error: error)
        }
    }
}
