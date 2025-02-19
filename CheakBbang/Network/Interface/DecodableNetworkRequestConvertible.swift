//
//  DecodableNetworkRequestConvertible.swift
//  CheakBbang
//
//  Created by 박다현 on 2/19/25.
//

import Foundation

protocol DecodableNetworkRequestConvertible: NetworkRequestConvertible {
    associatedtype DecodableType: Decodable
}

extension DecodableNetworkRequestConvertible {
    func decodeResponse(data: Data) throws -> DecodableType {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(DecodableType.self, from: data)
            return decodedData
        } catch {
            throw error
        }
    }
}
