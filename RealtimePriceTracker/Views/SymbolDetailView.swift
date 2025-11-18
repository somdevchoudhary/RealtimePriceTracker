//
//  SymbolDetailView.swift
//  RealtimePriceTracker
//
//  Created by Somdev Choudhary on 18/11/25.
//

import SwiftUI

struct SymbolDetailView: View {
    @Environment(AppState.self) private var appState
    let symbol: String
    
    private var stock: StockSymbol? {
        appState.symbols.first(where: { $0.symbol == symbol })
    }
    
    var body: some View {
        Group {
            if let stock = stock {
                VStack(spacing: 20) {
                    Text(stock.symbol)
                        .font(.largeTitle)
                        .bold()
                    
                    Text(String(format: "%.2f", stock.price))
                        .font(.system(size: 40, weight: .bold))
                    
                    if let previous = stock.previousPrice {
                        let diff = stock.price - previous
                        Text(diff >= 0 ? "↑ Increased" : "↓ Decreased")
                            .foregroundColor(diff >= 0 ? .green : .red)
                    }
                    
                    Text("This is a sample description for \(stock.symbol). You could load more detailed information about the company here.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Spacer()
                }
            } else {
                Text("Symbol not found.")
            }
        }
        .padding()
        .navigationTitle(symbol)
    }
}

#Preview {
    let appState = AppState()
    appState.symbols = [
        StockSymbol(symbol: "AAPL", price: 123.45, previousPrice: 120.0)
    ]
    return NavigationStack {
        SymbolDetailView(symbol: "AAPL")
            .environment(appState)
    }
}
