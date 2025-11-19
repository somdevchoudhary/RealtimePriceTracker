//
//  StockPresentationTests.swift
//  RealtimePriceTrackerTests
//
//  Created by Somdev Choudhary on 19/11/25.
//

import XCTest
@testable import RealtimePriceTracker

/// StockPresentationTests
final class StockPresentationTests: XCTestCase {
    
    private func makeSymbol(
        symbol: String = "AAPL",
        price: Double,
        previous: Double? = nil
    ) -> StockSymbol {
        StockSymbol(symbol: symbol, price: price, previousPrice: previous)
    }

    @MainActor
    func test_init_withNoPreviousPrice_setsNoneDirectionAndNoChangeTexts() {
        let stock = makeSymbol(price: 100.0, previous: nil)
        
        let presentation = StockPresentation(stock: stock)
        
        XCTAssertEqual(presentation.symbol, "AAPL")
        XCTAssertEqual(presentation.priceText, "100.00")
        XCTAssertEqual(presentation.direction, .none)
        XCTAssertNil(presentation.changeSymbol)
        XCTAssertNil(presentation.changeText)
    }
    
    @MainActor
    func test_init_withSamePrice_setsFlatDirectionAndNoChangeTexts() {
        let stock = makeSymbol(price: 100.0, previous: 100.0)
        
        let presentation = StockPresentation(stock: stock)
        
        XCTAssertEqual(presentation.direction, .flat)
        XCTAssertNil(presentation.changeSymbol)
        XCTAssertNil(presentation.changeText)
    }
    
    @MainActor
    func test_init_withHigherPrice_setsUpDirectionAndIncreaseTexts() {
        let stock = makeSymbol(price: 105.5, previous: 100.0)
        
        let presentation = StockPresentation(stock: stock)
        
        XCTAssertEqual(presentation.direction, .up)
        XCTAssertEqual(presentation.changeSymbol, "↑")
        XCTAssertEqual(presentation.changeText, "↑ Increased")
        XCTAssertEqual(presentation.priceText, "105.50")
    }
    
    @MainActor
    func test_init_withLowerPrice_setsDownDirectionAndDecreaseTexts() {
        let stock = makeSymbol(price: 95.25, previous: 100.0)
        
        let presentation = StockPresentation(stock: stock)
        
        XCTAssertEqual(presentation.direction, .down)
        XCTAssertEqual(presentation.changeSymbol, "↓")
        XCTAssertEqual(presentation.changeText, "↓ Decreased")
        XCTAssertEqual(presentation.priceText, "95.25")
    }
    
    func test_priceFormatting_alwaysHasTwoFractionDigits() {
        let stock = makeSymbol(price: 123.4, previous: nil)
        
        let presentation = StockPresentation(stock: stock)
        
        XCTAssertEqual(presentation.priceText, "123.40")
    }
}
