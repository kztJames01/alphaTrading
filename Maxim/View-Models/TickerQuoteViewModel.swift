//
//  TickerQuoteViewModel.swift
//  Maxim
//
//  Created by Kaung Zaw Thant on 1/26/25.
//
import Foundation
import ApiStocks
import SwiftUI

@MainActor
class TickerQuoteViewModel: ObservableObject{
    
    @Published var phase = FetchPhase<Quote>.initial
    var quote: Quote? { phase.value }
    var error: Error? { phase.error }
    
    let ticker: Ticker
    let stocksApi: StocksApi
    
    init(ticker: Ticker, stocksApi: StocksApi = ApiStocks()){
        self.ticker = ticker
        self.stocksApi = stocksApi
    }
    
    func fetchQuote() async {
        phase = .fetching
        
        do {
            let response = try! await stocksApi.fetchQuotes(symbol: ticker.symbol)
            if let quote = response.first {
                phase = .success(quote)
            }else{
                phase = .empty
            }
        } catch {
            print(error.localizedDescription)
            phase = .failure(error)
        }
    }
}
