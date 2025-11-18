//
//  FeedViewModel.swift
//  RealtimePriceTracker
//
//  Created by Somdev Choudhary on 18/11/25.
//

import Foundation
import Combine

final class FeedViewModel: ObservableObject {
    @Published var sortedSymbols: [StockSymbol] = []
    
    private let appState: AppState
    private let webSocket: WebSocketServiceType
    private var cancellables = Set<AnyCancellable>()
    private var timerCancellable: AnyCancellable?
    
    init(appState: AppState, webSocket: WebSocketServiceType) {
        self.appState = appState
        self.webSocket = webSocket
        bind()
        loadSymbols()
    }
    
    private func bind() {
        webSocket.messages
            .receive(on: DispatchQueue.main)
            .sink { [weak self] update in
                self?.apply(update)
            }
            .store(in: &cancellables)
    }
    
    private func loadSymbols() {
        let list = [
            "AAPL","GOOG","TSLA","AMZN","MSFT",
            "NVDA","META","BABA","ORCL","NFLX",
            "INTC","QCOM","IBM","AMD","ADBE",
            "CRM","SHOP","PYPL","PEP","KO",
            "V","MA","UBER","LYFT","SPOT"
        ]
        
        appState.symbols = list.map { symbol in
            StockSymbol(
                symbol: symbol,
                price: Double.random(in: 100...700),
                previousPrice: nil
            )
        }
        updateSorting()
    }
    
    func toggleFeed() {
        if appState.isRunning {
            stopFeed()
        } else {
            startFeed()
        }
    }
    
    private func startFeed() {
        guard !appState.isRunning else { return }
        appState.isRunning = true
        appState.isConnected = true
        webSocket.connect()
        
        timerCancellable = Timer.publish(every: 2, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.sendRandomUpdates()
            }
    }
    
    private func stopFeed() {
        appState.isRunning = false
        appState.isConnected = false
        timerCancellable?.cancel()
        timerCancellable = nil
        webSocket.disconnect()
    }
    
    private func sendRandomUpdates() {
        guard appState.isRunning, webSocket.isConnected else { return }
        
        for stock in appState.symbols {
            let newPrice = Double.random(in: 100...700)
            let update = PriceUpdate(symbol: stock.symbol, price: newPrice)
            self.apply(update)
        }
    }
    
    private func apply(_ update: PriceUpdate) {
        if let index = appState.symbols.firstIndex(where: { $0.symbol == update.symbol }) {
            var stock = appState.symbols[index]
            stock.previousPrice = stock.price
            stock.price = update.price
            appState.symbols[index] = stock
        }
        updateSorting()
    }
    
    private func updateSorting() {
        sortedSymbols = appState.symbols.sorted { $0.price > $1.price }
    }
}

