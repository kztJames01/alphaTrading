//
//  File.swift
//  
//
//  Created by Kaung Zaw Thant on 1/19/25.
//

import Foundation
public struct ChartResponse: Decodable{
    
    public let data: [ChartData]?
    public let error: [ErrorResponse]?
    
    enum CodingKeys: CodingKey{
        case chart
    }
    
    enum ChartKeys: CodingKey{
        case result
        case error
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let chartContainer = try? container.nestedContainer(keyedBy: ChartKeys.self, forKey: .chart){
            data = try? chartContainer.decodeIfPresent([ChartData].self, forKey: .result)
            error = try? chartContainer.decodeIfPresent([ErrorResponse].self, forKey: .error)
        }else{
            data = nil
            error = nil
        }
    }
}

public struct ChartData: Decodable{
    
    public let meta: ChartMeta
    public let indicators: [Indicator]
    
    enum CodingKeys: CodingKey{
        case meta
        case timestamp
        case indicators
    }
    enum IndicatorKeys: CodingKey{
        case quote
    }
    
    enum QuoteKeys: CodingKey{
        case high
        case low
        case open
        case close
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        meta = try container.decode(ChartMeta.self,forKey: .meta)
        
        let timestamps = try container.decodeIfPresent([Date].self, forKey: .timestamp) ?? []
        if let indicatorContainer = try? container.nestedContainer(keyedBy: IndicatorKeys.self, forKey: .indicators),
            var quotes = try? indicatorContainer.nestedUnkeyedContainer(forKey: .quote),
            let quoteContainer = try? quotes.nestedContainer(keyedBy: QuoteKeys.self){
            let highs = try quoteContainer.decodeIfPresent([Double?].self, forKey: .high) ?? []
            let lows = try quoteContainer.decodeIfPresent([Double?].self, forKey: .low) ?? []

            let opens = try quoteContainer.decodeIfPresent([Double?].self, forKey: .open) ?? []

            let closes = try quoteContainer.decodeIfPresent([Double?].self, forKey: .close) ?? []
            indicators = timestamps.enumerated().compactMap {
                (offset,timestamp) in
                guard
                    let open = opens[offset],
                    let low = lows[offset],
                    let high = highs[offset],
                    let close = closes[offset] 
                else{
                    return nil
                }
                return .init(timestamp: timestamp, open:open,close: close, high:high, low:low)
            }
        }else{
            self.indicators = []
        }
    }
    
    public init(meta: ChartMeta, indicators: [Indicator]){
        self.meta = meta
        self.indicators = indicators
    }
}

public struct ChartMeta: Decodable{
    
    public let currency: String
    public let symbol: String
    public let regularMarketPrice: Double
    public let chartPreviousClose: Double?
    public let gmtOffset: Int
    public let firstTradeDate: Date
    public let regularTradingPeriodStartDate: Date
    public let regularTradingPeriodEndDate: Date
    
    enum CodingKeys: CodingKey{
        case currency
        case symbol
        case firstTradeDate
        case regularMarketPrice
        case gmtOffset
        case chartPreviousClose
        case currentTradingPeriod
    }
    
    enum CurrentTradingPeriodKeys: String,CodingKey{
        case pre
        case regular
        case post
    }
    
    enum TradingKeys: String, CodingKey{
        case start
        case end
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.currency = try container.decodeIfPresent(String.self, forKey: .currency) ?? ""
        self.symbol = try container.decodeIfPresent(String.self, forKey: .symbol) ?? ""
        self.regularMarketPrice = try container.decodeIfPresent(Double.self, forKey: .regularMarketPrice) ?? 0.0
        self.firstTradeDate = try container.decodeIfPresent(Date.self, forKey: .firstTradeDate) ?? Date()
        self.chartPreviousClose = try container.decodeIfPresent(Double.self, forKey: .chartPreviousClose)
        self.gmtOffset = try
            container.decodeIfPresent(Int.self, forKey: .gmtOffset) ?? 0
        
        let currentTradingPeriodContainer = try? container.nestedContainer(keyedBy: CurrentTradingPeriodKeys.self, forKey: .currentTradingPeriod)
        let regularPeriod = try? currentTradingPeriodContainer?.nestedContainer(keyedBy: TradingKeys.self, forKey: .regular)
        self.regularTradingPeriodStartDate = try! regularPeriod?.decodeIfPresent(Date.self, forKey: .start) ?? Date()
        self.regularTradingPeriodEndDate = try!
        regularPeriod?.decodeIfPresent(Date.self, forKey: .end) ?? Date()
        
    }
}

public struct Indicator: Decodable {
    
    public let timestamp: Date
    public let open:Double
    public let close:Double
    public let high:Double
    public let low: Double
    
    public init(timestamp: Date,open: Double, close: Double, high: Double,  low: Double) {
        self.open = open
        self.timestamp = timestamp
        self.close = close
        self.high = high
        self.low = low
    }
    
    
}
