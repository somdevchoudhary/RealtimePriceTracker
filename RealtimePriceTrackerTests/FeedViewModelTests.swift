//
//  FeedViewModelTests.swift
//  RealtimePriceTrackerTests
//
//  Created by Somdev Choudhary on 18/11/25.
//

import XCTest
import Combine
@testable import RealtimePriceTracker

final class FeedViewModelTests: XCTestCase {

    private var appState: AppState!
    private var webSocket: MockWebSocketService!
    private var viewModel: FeedViewModel!

    override func setUp() {
        super.setUp()
        appState = AppState()
        webSocket = MockWebSocketService()
        viewModel = FeedViewModel(appState: appState, webSocket: webSocket)
    }

    override func tearDown() {
        viewModel = nil
        webSocket = nil
        appState = nil
        super.tearDown()
    }

    // MARK: - Tests

    func testToggleFeed_startsFeedAndConnectsWebSocket() {
        // Given
        appState.isRunning = false
        appState.isConnected = false

        // When
        viewModel.toggleFeed()

        // Then
        XCTAssertTrue(appState.isRunning, "Toggling feed should set isRunning = true")
        XCTAssertTrue(appState.isConnected, "Toggling feed should set isConnected = true")
        XCTAssertEqual(webSocket.connectCallCount, 1, "WebSocket.connect() should be called exactly once")
        XCTAssertTrue(webSocket.isConnected, "Mock websocket should reflect connected state")
    }

    func testToggleFeed_whenRunning_stopsFeedAndDisconnectsWebSocket() {
        // First start the feed
        viewModel.toggleFeed()

        // When we toggle again, it should stop
        viewModel.toggleFeed()

        XCTAssertFalse(appState.isRunning, "Second toggle should stop the feed")
        XCTAssertFalse(appState.isConnected, "Second toggle should mark as disconnected")
        XCTAssertEqual(webSocket.disconnectCallCount, 1, "WebSocket.disconnect() should be called exactly once")
        XCTAssertFalse(webSocket.isConnected)
    }

    func testIncomingPriceUpdate_updatesAppStateAndSortedSymbols() {
        // Given: FeedViewModel.loadSymbols() has already populated appState.symbols
        guard let first = appState.symbols.first else {
            XCTFail("Expected FeedViewModel to load initial symbols in init()")
            return
        }

        let targetSymbol = first.symbol
        let newPrice = first.price + 100

        // When: simulate an incoming websocket message
        let update = PriceUpdate(symbol: targetSymbol, price: newPrice)
        webSocket.push(update)

        // Give the main queue a moment to process .receive(on: .main)
        let expectation = expectation(description: "Price update applied")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)

        // Then: appState.symbols should reflect the new price
        let updatedStock = appState.symbols.first { $0.symbol == targetSymbol }
        XCTAssertEqual(updatedStock?.price, newPrice, "Price should be updated to the new value")
        XCTAssertNotNil(updatedStock?.previousPrice, "previousPrice should be set after an update")

        // And sortedSymbols should be sorted descending by price
        let prices = viewModel.sortedSymbols.map(\.price)
        let sorted = prices.sorted(by: >)
        XCTAssertEqual(prices, sorted, "sortedSymbols must be sorted in descending price order")
    }
}
