//
//  File.swift
//  
//
//  Created by Kaung Zaw Thant on 1/16/25.
//

import Foundation

public struct MarketDataResponse: Decodable{
    public let meta: MetaData?
    public let body: [String: TimeStamp]?
    public let message: String?
    public let error: [ErrorResponse]?
    
    enum CodingKeys: CodingKey{
        case meta
        case body
        case message
        case errors
    }
    
    public init(from decoder: Decoder) throws{
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        self.meta = try container?.decodeIfPresent(MetaData.self, forKey: .meta)
        self.body = try container?.decodeIfPresent([String:TimeStamp].self,forKey: .body)
        self.message = try container?.decodeIfPresent(String.self, forKey: .message)
        let rawErrors = (try? container?.decodeIfPresent([String:[String]].self, forKey: .errors)) ?? [:]
        error = ErrorResponse.fromDict(rawErrors)
    }
}
public struct MetaData: Decodable{
    
    public let gmtOffset: Int
    public let symbol: String
    public let currency: String
    public let regualrMarketPrice: Double?
    public let previousClose: Double?
    public var firstTradeDate: Date?
    
    enum CodingKeys: CodingKey{
        case currency
        case symbol
        case regularMarketPrice
        case previousClose
        case gmtOffset
        case firstTradeDate
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy:  CodingKeys.self)
        self.currency = try container.decodeIfPresent(String.self, forKey: .currency) ?? ""
        self.symbol = try container.decodeIfPresent(String.self, forKey: .symbol) ?? ""
        self.regualrMarketPrice = try container.decodeIfPresent(Double.self, forKey: .regularMarketPrice) ?? 0.00
        self.gmtOffset = try container.decodeIfPresent(Int.self, forKey: .gmtOffset) ?? 0
        self.previousClose = try container.decodeIfPresent(Double.self, forKey: .previousClose) ?? 0.00
        firstTradeDate = try container.decodeIfPresent(Date.self, forKey: .firstTradeDate) ?? Date()
        
        if let timestamp = try container.decodeIfPresent(Int.self, forKey: .firstTradeDate){
            self.firstTradeDate = Date(timeIntervalSince1970: TimeInterval(timestamp))
        }else{
            self.firstTradeDate = nil
        }
    }
    
}

public struct TimeStamp: Codable{
    
    public let date: String
    public let dateUTC: Int
    public let open: Double?
    public let close: Double?
    public let high: Double?
    public let low: Double?
    
    public init(date: String, open: Double?, close: Double?, high: Double?, low: Double?, dateUTC: Int) {
        
        self.dateUTC = dateUTC
        self.date = date
        self.open = open
        self.close = close
        self.high = high
        self.low = low
    }
    
    
}
