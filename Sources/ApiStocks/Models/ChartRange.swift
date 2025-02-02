//
//  File.swift
//  
//
//  Created by Kaung Zaw Thant on 1/19/25.
//

import Foundation

public enum ChartRange: String, CaseIterable, Hashable{
    
    case oneDay = "1d"
    case oneWeek = "5d"
    case oneMth = "1mo"
    case threeMth = "3mo"
    case sixMth = "6mo"
    case ytd
    case oneYear = "1y"
    case twoYear = "2y"
    case fiveYear = "5y"
    case tenYear = "10y"
    case max
    
    public var range: String{
        switch self{
        case .oneDay : return "1d"
        case .oneWeek : return "5d"
        case .oneMth : return "1mo"
        case.threeMth, .sixMth, .ytd, .oneYear, .twoYear: return "3mo"
        case .fiveYear, .tenYear : return "1y"
        case .max : return "ytd"
        }
    }
}
public enum ChartInterval: String, CaseIterable, Hashable{
    case fiveMin = "5m"
    case fifteenMin = "15m"
    case thirtyMin = "30m"
    case onehr = "60m"
    case oneDay = "1d"
    case oneWeek = "1wk"
    case oneMth = "1mo"
 
    
    public var interval: String{
        switch self{
        case .fiveMin : return "5m"
        case .fifteenMin : return "15m"
        case .thirtyMin : return "30m"
        case .onehr : return  "60m"
        case .oneDay : return "1d"
        case .oneWeek : return "1wk"
        case .oneMth : return "1mo"
        }
    }
}
