//
//  NetworkError.swift
//  CheakBbang
//
//  Created by 박다현 on 2/14/25.
//

import Foundation

enum NetworkError: Error {
    case notConnectedToInternet
    case timedOut
    case cannotFindHost
    case networkConnectionLost
    case noItem
    case unknownError(error: String)
    case hasNotChanged
}


extension NetworkError: Equatable {
    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.hasNotChanged, .hasNotChanged):
            return true
        case (.unknownError(let lhsMessage), .unknownError(let rhsMessage)):
            return lhsMessage == rhsMessage
        default:
            return false
        }
    }
}
