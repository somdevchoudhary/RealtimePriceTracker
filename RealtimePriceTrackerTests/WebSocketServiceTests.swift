//
//  WebSocketServiceTests.swift
//  RealtimePriceTrackerTests
//
//  Created by Somdev Choudhary on 19/11/25.
//

import XCTest
import Combine
@testable import RealtimePriceTracker

final class WebSocketServiceTests: XCTestCase {
    private var cancellables = Set<AnyCancellable>()
}

// MARK: - Helpers

private extension WebSocketServiceTests {
    /// Adjust this helper to match your real PriceUpdate struct.
    func makePriceUpdate(
        symbol: String = "AAPL",
        price: Double = 123.45
    ) -> PriceUpdate {
        // If your struct has more fields, update this accordingly.
        PriceUpdate(symbol: symbol, price: price)
    }
}

extension WebSocketServiceTests {

    func test_mock_connect_setsIsConnectedAndTracksCallCount() {
        let mock = MockWebSocketService()

        XCTAssertFalse(mock.isConnected)
        XCTAssertEqual(mock.connectCallCount, 0)

        mock.connect()

        XCTAssertTrue(mock.isConnected)
        XCTAssertEqual(mock.connectCallCount, 1)

        // Calling again should increment count again
        mock.connect()
        XCTAssertEqual(mock.connectCallCount, 2)
        XCTAssertTrue(mock.isConnected)
    }

    func test_mock_disconnect_setsIsConnectedFalseAndTracksCallCount() {
        let mock = MockWebSocketService()

        mock.connect()
        XCTAssertTrue(mock.isConnected)

        mock.disconnect()

        XCTAssertFalse(mock.isConnected)
        XCTAssertEqual(mock.disconnectCallCount, 1)
    }

    func test_mock_send_tracksLastSentMessageAndCallCount() {
        let mock = MockWebSocketService()
        let update1 = makePriceUpdate(symbol: "AAPL", price: 100)
        let update2 = makePriceUpdate(symbol: "TSLA", price: 200)

        XCTAssertEqual(mock.sendCallCount, 0)
        XCTAssertNil(mock.lastSentMessage)

        mock.send(update1)
        XCTAssertEqual(mock.sendCallCount, 1)
        XCTAssertEqual(mock.lastSentMessage?.symbol, "AAPL")
        XCTAssertEqual(mock.lastSentMessage?.price, 100)

        mock.send(update2)
        XCTAssertEqual(mock.sendCallCount, 2)
        XCTAssertEqual(mock.lastSentMessage?.symbol, "TSLA")
        XCTAssertEqual(mock.lastSentMessage?.price, 200)
    }

    func test_mock_push_emitsMessagesOnPublisher() {
        let mock = MockWebSocketService()
        let expected = makePriceUpdate(symbol: "NFLX", price: 555.5)

        let expectation = expectation(description: "Receive price update from mock")
        mock.messages
            .sink { update in
                XCTAssertEqual(update.symbol, expected.symbol)
                XCTAssertEqual(update.price, expected.price)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        mock.push(expected)

        wait(for: [expectation], timeout: 1.0)
    }
}
