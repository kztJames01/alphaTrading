//
//  Quotes+Extensions.swift
//  Trading
//
//  Created by Kaung Zaw Thant on 1/22/25.
//

import Foundation
import ApiStocks

extension Quote{
    
    var regularPriceText: String?{
        Utils.format(value: regularMarketPrice)
    }
    
    var regularDiffText: String?{
        guard let text = Utils.format(value: regularMarketChange) else{ return nil }
        return text.hasPrefix("-") ? text: "+\(text)"
    }
}
