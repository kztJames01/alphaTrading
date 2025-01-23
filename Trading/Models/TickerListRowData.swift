//
//  TickerListRowData.swift
//  Trading
//
//  Created by Kaung Zaw Thant on 1/20/25.
//

import Foundation

typealias priceChange = (price:String, change:String)

struct TickerListRowData{
    
    enum RowType{
        case main
        case search(isSaved: Bool, onButtonTapped:()-> Void)
    }
    
    let symbol: String?
    let name : String?
    let price: priceChange?
    let type: RowType
}
