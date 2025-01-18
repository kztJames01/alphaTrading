//
//  File.swift
//  
//
//  Created by Kaung Zaw Thant on 1/16/25.
//

import Foundation

public struct DynamicKey: CodingKey{
    public let stringValue: String
    public let intValue: Int?
    
    public init?(stringValue: String){
        self.stringValue = stringValue
        self.intValue = nil
    }
    
    public init?(intValue: Int){
        self.stringValue = "\(intValue)"
        self.intValue = intValue
    }
}
public struct MarketDataResponse: Decodable{
    public let metaData: MetaData?
    public var data: [TimeStamp]?
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
        metaData = try container?.decodeIfPresent(MetaData.self, forKey: .meta)
        if let bodyContainer = try? container?.nestedContainer(keyedBy: DynamicKey.self, forKey: .body){
            
            //create dynamic key
            var decodedData: [TimeStamp] = []
            for key in bodyContainer.allKeys{
                if let timeStampData = try? bodyContainer.decodeIfPresent(TimeStamp.self, forKey: key){
                    decodedData.append(timeStampData)
                }
            }
            data = decodedData
        }else{
            print("No body key found")
            self.data = nil
        }
        message = try container?.decodeIfPresent(String.self, forKey: .message)
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

public struct TimeStamp: Decodable{
    
    public let date: String
    public let date_utc: Int
    public let open: Double
    public let close: Double
    public let high: Double
    public let low: Double
    public let volume: Int
    
    public init(date: String, open: Double, close: Double, high: Double, low: Double, date_utc: Int,volume: Int) {
        
        self.date_utc = date_utc
        self.date = date
        self.open = open
        self.close = close
        self.high = high
        self.low = low
        self.volume = volume
    }
    
    
}
