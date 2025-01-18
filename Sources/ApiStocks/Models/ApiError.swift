//
//  File.swift
//  
//
//  Created by Kaung Zaw Thant on 1/17/25.
//

import Foundation

public enum ApiError: CustomNSError{
    case invalidURL
    case invalidResponseType
    case httpStatusCodeFailed(statusCode:Int, errors: [ErrorResponse]?)
    
    public static var errorDomain: String{
        "ApiStocks"
    }
    
    public var errorCode: Int{
        switch self{
        case .invalidURL : return 0
        case .invalidResponseType : return 1
        case .httpStatusCodeFailed: return 2
        }
    }
    
    public var errorUserInfo: [String : Any]{
        let text:String
        switch self{
        case .invalidURL: text = "Invalid URL"
        case .invalidResponseType: text = "Invalid Response Type"
        case let .httpStatusCodeFailed(statusCode, errors):
            if let errors = errors, !errors.isEmpty {
                let errorMessages = errors
                    .map{ "Code: \($0.code), Message: \($0.description)"
                    }.joined(separator: "; ")
                text = "Error: Status Code \(statusCode), Details: [\(errorMessages)]"
            }else{
                text = "Error: Status Code \(statusCode)"
            }
        }
        return [NSLocalizedDescriptionKey: text]
    }
}
