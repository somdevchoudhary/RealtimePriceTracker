//
//  AppState.swift
//  RealtimePriceTracker
//
//  Created by Somdev Choudhary on 18/11/25.
//

import Foundation
import Observation

@Observable
final class AppState {
    var symbols: [StockSymbol] = []
    var isRunning: Bool = false
    var isConnected: Bool = false
}
