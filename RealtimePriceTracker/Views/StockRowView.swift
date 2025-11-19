//
//  StockRowView.swift
//  RealtimePriceTracker
//
//  Created by Somdev Choudhary on 18/11/25.
//

import SwiftUI

/// StockRowView
struct StockRowView: View {
    let stock: StockSymbol
    
    private var presentation: StockPresentation {
        StockPresentation(stock: stock)
    }
    
    private func color(for direction: PriceChangeDirection) -> Color {
        switch direction {
        case .up:   return .green
        case .down: return .red
        case .flat, .none: return .clear
        }
    }
    
    var body: some View {
        HStack {
            Text(presentation.symbol)
                .font(.headline)
                .foregroundStyle(.primary)
            
            Spacer()
            
            Text(presentation.priceText)
                .fontWeight(.bold)
                .foregroundStyle(.primary)
            
            if let symbol = presentation.changeSymbol {
                Text(symbol)
                    .foregroundStyle(color(for: presentation.direction))
            }
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
    }
}

#Preview {
    StockRowView(
        stock: StockSymbol(symbol: "AAPL", price: 123.45, previousPrice: 120.00)
    )
    .padding()
}
