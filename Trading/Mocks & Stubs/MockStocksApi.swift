//
//  MockStocksApi.swift
//  Trading
//
//  Created by Kaung Zaw Thant on 1/22/25.
//

import Foundation
import ApiStocks

#if DEBUG

struct MockStocksApi: StocksApi{
    
    var stubbedSearchTickerCallback: (() async throws -> [Ticker])!
    func searchData(search: String) async throws -> [Ticker] {
        try await stubbedSearchTickerCallback()
    }
    
    var stubbedFetchQuoteCallback: (() async throws -> [Quote])!
    func fetchQuotes(symbol: String) async throws -> [Quote] {
        try await stubbedFetchQuoteCallback()
    }
    
    var stubbedFetchHistoryCallback: (() async throws -> [(MetaData,[TimeStamp])])!
    func fetchHistoryData(symbol: String, interval: HistoryRange,diffandsplits: Bool) async throws -> [(MetaData,[TimeStamp])]
    {
        try await stubbedFetchHistoryCallback()
    }
}


#endif
