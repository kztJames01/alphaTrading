//
//  QuoteViewModel.swift
//  Trading
//
//  Created by Kaung Zaw Thant on 1/22/25.
//

import SwiftUI
import Foundation
import ApiStocks

@MainActor
class QuoteViewModel: ObservableObject{
    
    @Published var quotesDict: [String:Quote] = [:]
    private let stocksApi: StocksApi
    
    init(stocksApi: StocksApi = ApiStocks()){
        self.stocksApi = stocksApi
    }
    
    public func priceForTicker(_ ticker: Ticker) -> priceChange?{
        guard let quote = quotesDict[ticker.symbol],
              let price = quote.regularPriceText,
                let change = quote.regularDiffText
        else{
            return nil
        }
        return (price, change)
    }
    
    public func fetchQuotes(tickers: [Ticker]) async {
        guard !tickers.isEmpty else { return }
        do {
            let symbols = tickers.map { $0.symbol }.joined(separator: ".")
            let quotes = try? await stocksApi.fetchQuotes(symbol: symbols)
            var dict = [String:Quote]()
            quotes?.forEach { dict[$0.symbol] = $0 }
            self.quotesDict = dict
        }catch{
            print(error.localizedDescription)
        }
    }
}

