//
//  StocksApi.swift
//  Trading
//
//  Created by Kaung Zaw Thant on 1/22/25.
//

import Foundation
import ApiStocks

protocol StocksApi {
    func fetchHistoryData(symbol: String, interval: HistoryRange,diffandsplits: Bool) async throws -> [(MetaData,[TimeStamp])]
    func searchData(search: String) async throws -> [Ticker]
    func fetchQuotes(symbol:String) async throws -> [Quote]
}

extension ApiStocks: StocksApi{}
