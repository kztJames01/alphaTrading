//
//  File.swift
//  
//
//  Created by Kaung Zaw Thant on 1/14/25.
//

import Foundation

public struct QuoteResponse: Decodable {
    
    public let data: [Quote]?
    public let error: [ErrorResponse]?
    public let message: String?
    
    enum CodingKeys: String, CodingKey{
        case body
        case message
        case errors
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy:
                                                CodingKeys.self)
        
        if let quoteResponseContainer = try?
            container.decodeIfPresent([Quote].self, forKey: .body){
            self.data = quoteResponseContainer
            self.error = nil
            self.message = nil
            
        }else if let messageResponse = try?
                    container.decodeIfPresent(String.self,forKey: .message),
                 let rawErrors = try? container.decodeIfPresent([String:[String]].self, forKey: .errors){
            self.data = nil
            self.error = ErrorResponse.fromDict(rawErrors)
            self.message = messageResponse
            
        } else{
            self.data = nil
            self.error = nil
            self.message = nil
        }
    }
}

public struct Quote: Decodable, Identifiable, Hashable {
    
    public let id = UUID()
    
    public let currency: String?
    public let marketState: String?
    public let fullExchangeName: String?
    public let displayName: String?
    public let symbol: String
    public let regularMarketPrice: Double?
    public let regularMarketChange: Double?
    public let regularMarketChangePercent: Double?
    public let regularMarketChangePreviousClose: Double?
    
    public let postMarketPrice: Double?
    public let postMarketChange: Double?
    
    public let regularMarketOpen: Double?
    public let regularMarketDayHigh: Double?
    public let regularMarketDayLow: Double?
    public let regularMarketVolume: Double?
    
    public let trailingPE: Double?
    public let marketCap: Double?
    
    public let fiftyTwoWeekLow: Double?
    public let fiftyTwoWeekHigh: Double?
    public let averageDailyVolume3Month:Double?
    
    public let trailingAnnualDividendYield: Double?
    public let epsTrailingTwelveMonths: Double?
    
    public init(currency: String? = nil, marketState: String? = nil, fullExchangeName: String? = nil, displayName: String? = nil, symbol: String, regularMarketPrice: Double? = nil, regularMarketChange: Double? = nil, regularMarketChangePercent: Double? = nil, regularMarketChangePreviousClose: Double? = nil, postMarketPrice: Double? = nil, postMarketChange: Double? = nil, regularMarketOpen: Double? = nil, regularMarketDayHigh: Double? = nil, regularMarketDayLow: Double? = nil, regularMarketVolume: Double? = nil, trailingPE: Double? = nil, marketCap: Double? = nil, fiftyTwoWeekLow: Double? = nil, fiftyTwoWeekHigh: Double? = nil, averageDailyVolume3Month: Double? = nil, trailingAnnualDividendYield: Double? = nil, epsTrailingTwelveMonths: Double? = nil) {
        self.currency = currency
        self.marketState = marketState
        self.fullExchangeName = fullExchangeName
        self.displayName = displayName
        self.symbol = symbol
        self.regularMarketPrice = regularMarketPrice
        self.regularMarketChange = regularMarketChange
        self.regularMarketChangePercent = regularMarketChangePercent
        self.regularMarketChangePreviousClose = regularMarketChangePreviousClose
        self.postMarketPrice = postMarketPrice
        self.postMarketChange = postMarketChange
        self.regularMarketOpen = regularMarketOpen
        self.regularMarketDayHigh = regularMarketDayHigh
        self.regularMarketDayLow = regularMarketDayLow
        self.regularMarketVolume = regularMarketVolume
        self.trailingPE = trailingPE
        self.marketCap = marketCap
        self.fiftyTwoWeekLow = fiftyTwoWeekLow
        self.fiftyTwoWeekHigh = fiftyTwoWeekHigh
        self.averageDailyVolume3Month = averageDailyVolume3Month
        self.trailingAnnualDividendYield = trailingAnnualDividendYield
        self.epsTrailingTwelveMonths = epsTrailingTwelveMonths
    }
}
