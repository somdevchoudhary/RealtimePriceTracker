//
//  SymbolDetailView.swift
//  RealtimePriceTracker
//
//  Created by Somdev Choudhary on 18/11/25.
//

import SwiftUI

struct SymbolDetailView: View {
    @EnvironmentObject var appState: AppState
    let symbol: String
    
    private var stock: StockSymbol? {
        appState.symbols.first(where: { $0.symbol == symbol })
    }
    
    private var formattedPrice: String {
        guard let price = stock?.price else { return "—" }
        return price.formatted(.number.precision(.fractionLength(2)))
    }
    
    private var priceChange: (text: String, color: Color)? {
        guard let stock, let previous = stock.previousPrice else { return nil }
        let diff = stock.price - previous
        let isUp = diff >= 0
        
        return (
            text: isUp ? "↑ Increased" : "↓ Decreased",
            color: isUp ? .green : .red
        )
    }
    
    var body: some View {
        VStack(spacing: 20) {
            if let stock {
                Text(stock.symbol)
                    .font(.largeTitle.bold())
                    .foregroundStyle(.primary)
                    .padding(.top, 40)
                Text(formattedPrice)
                    .font(.system(size: 40, weight: .bold))
                    .foregroundStyle(.primary)
                
                if let change = priceChange {
                    Text(change.text)
                        .foregroundStyle(change.color)
                }
                
                Text("This is a sample description for \(stock.symbol). You could load more detailed information about the company here.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Spacer()
            } else {
                Text("Symbol not found.")
                    .foregroundStyle(.secondary)
                Spacer()
            }
        }
        .padding()
        .navigationTitle(symbol)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    let appState = AppState()
    appState.symbols = [
        StockSymbol(symbol: "AAPL", price: 123.45, previousPrice: 120.0)
    ]
    
    return NavigationStack {
        SymbolDetailView(symbol: "AAPL")
            .environmentObject(appState)
    }
}
