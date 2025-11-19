//
//  MockWebSocketService.swift
//  RealtimePriceTrackerTests
//
//  Created by Somdev Choudhary on 18/11/25.
//

import Foundation
import Combine
@testable import RealtimePriceTracker

final class MockWebSocketService: WebSocketServiceType {

    // Subject we control from tests
    private let subject = PassthroughSubject<PriceUpdate, Never>()

    var messages: AnyPublisher<PriceUpdate, Never> {
        subject.eraseToAnyPublisher()
    }

    var isConnected: Bool = false

    func connect() {
        connectCallCount += 1
        isConnected = true
    }

    func disconnect() {
        disconnectCallCount += 1
        isConnected = false
    }

    func send(_ message: PriceUpdate) {
        sendCallCount += 1
        lastSentMessage = message
    }

    // MARK: - Test helpers / spies

    private(set) var connectCallCount = 0
    private(set) var disconnectCallCount = 0
    private(set) var sendCallCount = 0
    private(set) var lastSentMessage: PriceUpdate?

    /// Push a fake message as if it came from the server.
    func push(_ update: PriceUpdate) {
        subject.send(update)
    }
}
