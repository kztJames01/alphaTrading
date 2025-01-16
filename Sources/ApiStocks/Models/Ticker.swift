//
//  File.swift
//  
//
//  Created by Kaung Zaw Thant on 1/16/25.
//

import Foundation

public struct SearchTicker: Decodable{
    
    public let data: [Ticker]?
    public let error: [ErrorResponse]?
    public let message: String?
    
    enum CodingKeys: CodingKey{
        case message
        case body
        case errors
    }
    
    public init(from decoder: Decoder) throws{
        let container = try decoder.container(keyedBy:
                                                CodingKeys.self)
        
        data = try? container.decodeIfPresent([Ticker].self, forKey: .body)
        let rawErrors = try? container.decodeIfPresent([String:[String]].self, forKey: .errors)
        error = ErrorResponse.fromDict(rawErrors ?? ["":[""]])
        message = try? container.decodeIfPresent(String.self, forKey: .message)
    }
}

public struct Ticker: Codable, Hashable, Identifiable, Equatable{
    
    public let id = UUID()
    
    public let symbol: String
    public let name: String?
    public let exch: String?
    public let exchDisp: String?
    public let typeDisp: String?
    
    init(symbol: String, name: String?, exch: String?, exchDisp: String?, typeDisp: String?) {
        self.symbol = symbol
        self.name = name
        self.exch = exch
        self.exchDisp = exchDisp
        self.typeDisp = typeDisp
    }
}
