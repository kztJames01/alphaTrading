//
//  File.swift
//  
//
//  Created by Kaung Zaw Thant on 1/16/25.
//

import Foundation

public struct SearchData: Decodable{
    
    public let data: [Ticker]?
    public let error: [ErrorResponse]?
    public let message: String?
    
    enum CodingKeys: String,CodingKey{
        case message
        case body
        case errors
    }
    
    public init(from decoder: Decoder) throws{
        let container = try decoder.container(keyedBy:
                                                CodingKeys.self)
        
        if let searchResponseContainer = try?
            container.decodeIfPresent([Ticker].self, forKey: .body){
            self.data = searchResponseContainer
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

public struct Ticker: Codable, Hashable, Identifiable, Equatable{
    
    public let id = UUID()
    
    public let symbol: String
    public let name: String
    public let exch: String?
    public let exchDisp: String?
    public let typeDisp: String?
    
    init(symbol: String, name: String, exch: String?, exchDisp: String?, typeDisp: String?) {
        self.symbol = symbol
        self.name = name
        self.exch = exch
        self.exchDisp = exchDisp
        self.typeDisp = typeDisp
    }
}
