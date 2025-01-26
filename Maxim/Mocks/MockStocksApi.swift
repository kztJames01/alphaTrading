//
//  MockStocksApi.swift
//  Trading
//
//  Created by Kaung Zaw Thant on 1/22/25.
//

import Foundation
import ApiStocks

#if DEBUG

public struct MockStocksApi: StocksApi{
    
    public var stubbedSearchTickerCallback: (() async throws -> [Ticker])!
    public func searchData(search: String,isEquity: Bool=true) async throws -> [Ticker] {
        try await stubbedSearchTickerCallback()
    }
    
    public var stubbedFetchQuoteCallback: (() async throws -> [Quote])!
    public func fetchQuotes(symbol: String) async throws -> [Quote] {
        try await stubbedFetchQuoteCallback()
    }
    
    public var stubbedFetchHistoryCallback: (() async throws -> [(MetaData,[TimeStamp])])!
    public func fetchHistoryData(symbol: String, interval: HistoryRange,diffandsplits: Bool) async throws -> [(MetaData,[TimeStamp])]
    {
        try await stubbedFetchHistoryCallback()
    }
}


#endif
