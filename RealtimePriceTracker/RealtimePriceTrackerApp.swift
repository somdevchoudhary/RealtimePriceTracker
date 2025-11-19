//
//  RealtimePriceTrackerApp.swift
//  RealtimePriceTracker
//
//  Created by Somdev Choudhary on 18/11/25.
//

import SwiftUI

@main
struct RealtimePriceTrackerApp: App {
    @StateObject var appState: AppState
    @StateObject private var feedViewModel: FeedViewModel
    @State private var path = NavigationPath()

    init() {
        let appState = AppState()
        let webSocket: WebSocketServiceType = WebSocketService()
        let feedViewModel = FeedViewModel(
            appState: appState,
            webSocket: webSocket
        )
        _appState = StateObject(wrappedValue: appState)
        _feedViewModel = StateObject(wrappedValue: feedViewModel)
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $path) {
                FeedView()
            }
            .environmentObject(appState)
            .environmentObject(feedViewModel)
            .onOpenURL { url in
                handleDeeplink(url)
            }
        }
    }
    
    /// Handle Deeplink
    /// - Parameter url: url
    private func handleDeeplink(_ url: URL) {
        guard url.scheme == "stocks",
              url.host == "symbol" else { return }
        let symbol = url.lastPathComponent.uppercased()
        if !appState.symbols.contains(where: { $0.symbol == symbol }) {
            appState.symbols.append(
                StockSymbol(symbol: symbol, price: 0, previousPrice: nil)
            )
        }
        path = NavigationPath()
        path.append(symbol)
    }
}
