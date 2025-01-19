//
//  File.swift
//  
//
//  Created by Kaung Zaw Thant on 1/18/25.
//

import Foundation

public enum HistoryRange: String, CaseIterable{
    case fiveMin = "5m"
    case fifteenMin = "15m"
    case thirtyMin = "30m"
    case onehr = "1h"
    case oneDay = "1d"
    case oneWeek = "1wk"
    case oneMth = "1mo"
    case threeMth = "3mo"
    
    public var interval: String{
        switch self{
        case .fiveMin : return "5m"
        case .fifteenMin : return "15m"
        case .thirtyMin : return "30m"
        case .onehr : return  "1h"
        case .oneDay : return "1d"
        case .oneWeek : return "1wk"
        case .oneMth : return "1mo"
        case .threeMth : return "3mo"
        }
    }
}
