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
    
    func priceForTicker(_ ticker: Ticker) -> priceChange?{
        guard let quote = quotesDict[ticker.symbol],
              let price = quote.regularPriceText,
                let change = quote.regularDiffText
        else{
            return nil
        }
        return (price, change)
    }
}

