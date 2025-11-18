//
//  RealtimePriceTrackerApp.swift
//  RealtimePriceTracker
//
//  Created by Somdev Choudhary on 18/11/25.
//

import SwiftUI
import Observation

@main
struct RealtimePriceTrackerApp: App {
    @State var appState: AppState
    @State private var feedViewModel: FeedViewModel
    
    init() {
        let appState = AppState()
        let webSocket: WebSocketServiceType = WebSocketService()
        let feedViewModel = FeedViewModel(
            appState: appState,
            webSocket: webSocket
        )
        _appState = State(initialValue: appState)
        _feedViewModel = State(initialValue: feedViewModel)
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                FeedView()
            }
            .environment(appState)
            .environment(feedViewModel)
        }
    }
}
