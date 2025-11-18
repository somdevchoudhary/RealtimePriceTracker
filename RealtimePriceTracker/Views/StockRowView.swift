//
//  StockRowView.swift
//  RealtimePriceTracker
//
//  Created by Somdev Choudhary on 18/11/25.
//

import SwiftUI

struct StockRowView: View {
    let stock: StockSymbol
    
    private var formattedPrice: String {
        String(format: "%.2f", stock.price)
    }
    
    private var changeSymbol: String? {
        guard let previous = stock.previousPrice else { return nil }
        let diff = stock.price - previous
        return diff == 0 ? nil : (diff > 0 ? "↑" : "↓")
    }
    
    private var changeColor: Color {
        guard let previous = stock.previousPrice else { return .clear }
        let diff = stock.price - previous
        return diff >= 0 ? .green : .red
    }
    
    var body: some View {
        HStack {
            Text(stock.symbol)
                .font(.headline)
                .foregroundStyle(.primary)
            
            Spacer()
            
            Text(formattedPrice)
                .fontWeight(.bold)
                .foregroundStyle(.primary)
            
            if let symbol = changeSymbol {
                Text(symbol)
                    .foregroundStyle(changeColor)
            }
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
    }
}


#Preview {
    StockRowView(stock: StockSymbol(symbol: "AAPL", price: 123.45, previousPrice: 120.00))
        .padding()
}
