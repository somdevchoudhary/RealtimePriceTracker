//
//  AppState.swift
//  RealtimePriceTracker
//
//  Created by Somdev Choudhary on 18/11/25.
//

import Foundation
import Combine

final class AppState: ObservableObject {
    @Published var symbols: [StockSymbol] = []
    @Published var isRunning: Bool = false
    @Published var isConnected: Bool = false
}
