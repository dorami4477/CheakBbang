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
    let repository = LevelRepository()
    
    @MainActor
    func fetchLevel() async throws -> [LevelModel] {
        do {
            let value = try await self.callRequest(api: .level, model: [LevelDTO].self)
            repository?.addLevelList(value.map{ $0.toEntity() })
            
            let result = value.prefix(UserDefaultsManager.level - 1).map { $0.toModel() }

            return result
        } catch {
            if let myError = error as? NetworkError, myError == .hasNotChanged {
                if let value = repository?.fetchLevelList() {
                   
                    return Array(value.prefix(UserDefaultsManager.level - 1))
                } else {
                    return []
                }
            } else {
                throw networkErrorHandling(error: error)
            }
        }
    }
}
