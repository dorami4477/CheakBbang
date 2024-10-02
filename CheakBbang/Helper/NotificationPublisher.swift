//
//  NotificationPublisher.swift
//  CheakBbang
//
//  Created by 박다현 on 10/2/24.
//

import Foundation
import Combine

class NotificationPublisher {
    static let shared = NotificationPublisher()
    
    let publisher = PassthroughSubject<Void, Never>()
    
    private init() {}
    
    func send() {
        publisher.send()
    }
}
