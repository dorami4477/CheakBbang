//
//  LevelNetworkManager.swift
//  CheakBbang
//
//  Created by 박다현 on 2/14/25.
//

import Foundation

final class LevelNetworkManager: DecodableNetworkRequestConvertible {
    typealias DecodableType = [LevelDTO]
    typealias api = LevelRouter
    let repository = LevelRepository()
    
    @MainActor
    func fetchLevel() async throws -> [LevelModel] {
        do {
            let rawData = try await self.callRequest(api: .level, etagKey: "levelEtag")
            let decodedData = try decodeResponse(data: rawData)
            repository?.addLevelList(decodedData.map{ $0.toEntity() })
            
            let result = decodedData.prefix(UserDefaultsManager.level - 1).map { $0.toModel() }
            
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
