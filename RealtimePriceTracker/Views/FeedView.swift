//
//  FeedView.swift
//  RealtimePriceTracker
//
//  Created by Somdev Choudhary on 18/11/25.
//

import SwiftUI
import Observation

/// FeedView
struct FeedView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var viewModel: FeedViewModel
    
    var body: some View {
        VStack {
            header
            List(viewModel.sortedSymbols) { stock in
                NavigationLink(value: stock.symbol) {
                    StockRowView(stock: stock)
                }
            }
            .listStyle(.plain)
        }
        .navigationTitle("Feed")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: String.self) { symbol in
            SymbolDetailView(symbol: symbol)
        }
    }
    
    private var header: some View {
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
    }
}

#Preview {
    let appState = AppState()
    let ws: WebSocketServiceType = WebSocketService()
    let vm = FeedViewModel(appState: appState, webSocket: ws)
    
    NavigationStack {
        FeedView()
            .environmentObject(appState)
            .environmentObject(vm)
    }
}
