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
    case unknownError
    case hasNotChanged
}
