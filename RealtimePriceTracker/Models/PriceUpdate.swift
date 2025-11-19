//
//  PriceUpdate.swift
//  RealtimePriceTracker
//
//  Created by Somdev Choudhary on 18/11/25.
//

import Foundation

/// PriceUpdate
struct PriceUpdate: Codable, Equatable {
    let symbol: String
    let price: Double
}
