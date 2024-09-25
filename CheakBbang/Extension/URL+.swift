//
//  URL+.swift
//  CheakBbang
//
//  Created by 박다현 on 9/25/24.
//

import Foundation

extension URL {
    func appendingQueryParameter(_ name: String, _ value: String) -> URL {
        var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: false)!
        var queryItems = urlComponents.queryItems ?? []
        queryItems.append(URLQueryItem(name: name, value: value))
        urlComponents.queryItems = queryItems
        return urlComponents.url!
    }
}

