//
//  StockRowView.swift
//  RealtimePriceTracker
//
//  Created by Somdev Choudhary on 18/11/25.
//

import SwiftUI

struct StockRowView: View {
    let stock: StockSymbol

    var body: some View {
        HStack {
            Text(stock.symbol)
                .font(.headline)
                .foregroundStyle(.primary)

            Spacer()

            Text(String(format: "%.2f", stock.price))
                .bold()
                .foregroundStyle(.primary)

            if let previous = stock.previousPrice {
                let diff = stock.price - previous
                Text(diff >= 0 ? "↑" : "↓")
                    .foregroundColor(diff >= 0 ? .green : .red)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    StockRowView(stock: StockSymbol(symbol: "AAPL", price: 123.45, previousPrice: 120.00))
        .previewLayout(.sizeThatFits)
        .padding()
}
