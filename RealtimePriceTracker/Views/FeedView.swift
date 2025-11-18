//
//  FeedView.swift
//  RealtimePriceTracker
//
//  Created by Somdev Choudhary on 18/11/25.
//

import SwiftUI
import Observation

struct FeedView: View {
    @Environment(AppState.self) private var appState
    @Environment(FeedViewModel.self) private var viewModel

    var body: some View {
        VStack {
            HStack {
                Circle()
                    .fill(appState.isConnected ? Color.green : Color.red)
                    .frame(width: 12, height: 12)
                Text(appState.isConnected ? "Connected" : "Disconnected")
                    .font(.caption)
                Spacer()
                Button(appState.isRunning ? "Stop" : "Start") {
                    viewModel.toggleFeed()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding([.horizontal, .top])
            
            List(viewModel.sortedSymbols) { stock in
                NavigationLink(value: stock.symbol) {
                    StockRowView(stock: stock)
                }
            }
            .listStyle(.plain)
            .navigationTitle("Feed")
        }
    }
}

#Preview {
    let appState = AppState()
    let ws: WebSocketServiceType = WebSocketService()
    let vm = FeedViewModel(appState: appState, webSocket: ws)
    FeedView()
        .environment(appState)
        .environment(vm)
}
