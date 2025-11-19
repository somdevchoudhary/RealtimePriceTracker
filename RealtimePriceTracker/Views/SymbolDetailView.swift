//
//  SymbolDetailView.swift
//  RealtimePriceTracker
//
//  Created by Somdev Choudhary on 18/11/25.
//

import SwiftUI

/// SymbolDetailView
struct SymbolDetailView: View {
    @EnvironmentObject var appState: AppState
    let symbol: String
    
    private var stock: StockSymbol? {
        appState.symbols.first(where: { $0.symbol == symbol })
    }
    
    private var presentation: StockPresentation? {
        stock.map { StockPresentation(stock: $0) }
    }
    
    private func color(for direction: PriceChangeDirection) -> Color {
        switch direction {
        case .up:   return .green
        case .down: return .red
        case .flat: return .primary
        case .none: return .secondary
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            if let presentation {
                Text(presentation.symbol)
                    .font(.largeTitle.bold())
                    .foregroundStyle(.primary)
                    .padding(.top, 40)
                
                Text(presentation.priceText)
                    .font(.system(size: 40, weight: .bold))
                    .foregroundStyle(.primary)
                
                if let changeText = presentation.changeText {
                    Text(changeText)
                        .foregroundStyle(color(for: presentation.direction))
                }
                
                Text("This is a sample description for \(presentation.symbol). You could load more detailed information about the company here.")
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
