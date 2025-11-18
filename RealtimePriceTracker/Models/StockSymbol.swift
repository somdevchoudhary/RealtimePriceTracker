//
//  StockSymbol.swift
//  RealtimePriceTracker
//
//  Created by Somdev Choudhary on 18/11/25.
//

import Foundation

struct StockSymbol: Identifiable, Hashable {
    let id = UUID()
    let symbol: String
    var price: Double
    var previousPrice: Double?
}
