//
//  TradingTests.swift
//  TradingTests
//
//  Created by Kaung Zaw Thant on 1/19/25.
//

import XCTest
@testable import Trading

final class TradingTests: XCTestCase {
    
    var viewModel: QuoteViewModel!
    var mockApi: MockStocksApi!
    
    @MainActor override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        mockApi = MockStocksApi()
        viewModel = QuoteViewModel(stocksApi: mockApi)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
        mockApi = nil
        super.tearDown()
    }
    func testPriceForTickerReturnsCorrectData() async{
        // Given: Add a test quote to the dictionary
        let testQuote = Quote(symbol: "AAPL", regularPriceText: "$150", regularDiffText: "+2.5")
        viewModel.quotesDict["AAPL"] = testQuote
        let ticker = Ticker(symbol: "AAPL", name: "Apple Inc.")

        // When: Retrieve price information
        let priceChange = viewModel.priceForTicker(ticker)

        // Then: Validate the result
        XCTAssertNotNil(priceChange)
        XCTAssertEqual(priceChange?.0, "$150")
        XCTAssertEqual(priceChange?.1, "+2.5")
    }
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
