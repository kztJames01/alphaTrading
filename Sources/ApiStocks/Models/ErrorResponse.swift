//
//  File.swift
//  
//
//  Created by Kaung Zaw Thant on 1/15/25.
//

import Foundation

public struct ErrorResponse: Codable{
    public let code: String
    public let description: String
    
    public init(code: String, description: String) {
        self.code = code
        self.description = description
    }
}
