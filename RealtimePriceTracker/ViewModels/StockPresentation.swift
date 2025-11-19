//
//  StockPresentation.swift
//  RealtimePriceTracker
//
//  Created by Somdev Choudhary on 19/11/25.
//

import Foundation

enum PriceChangeDirection {
    case up
    case down
    case flat
    case none
}

struct StockPresentation {
    let symbol: String
    let priceText: String
    let changeSymbol: String?    // "↑" / "↓" / nil
    let changeText: String?      // "↑ Increased" / "↓ Decreased" / nil
    let direction: PriceChangeDirection
    
    init(stock: StockSymbol) {
        symbol = stock.symbol
        priceText = String(format: "%.2f", stock.price)
        
        guard let previous = stock.previousPrice else {
            changeSymbol = nil
            changeText = nil
            direction = .none
            return
        }
        
        let diff = stock.price - previous
        
        if diff == 0 {
            changeSymbol = nil
            changeText = nil
            direction = .flat
        } else if diff > 0 {
            changeSymbol = "↑"
            changeText = "↑ Increased"
            direction = .up
        } else {
            changeSymbol = "↓"
            changeText = "↓ Decreased"
            direction = .down
        }
    }
}
