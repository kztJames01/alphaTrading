//
//  Quotes+Extensions.swift
//  Trading
//
//  Created by Kaung Zaw Thant on 1/22/25.
//

import Foundation
import ApiStocks

extension Quote{
    
    var isTrading: Bool{
        guard let marketState, marketState == "REGULAR" else{
            return false
        }
        return true
    }
    
    var regularPriceText: String?{
        Utils.format(value: regularMarketPrice)
    }
    
    var regularDiffText: String?{
        guard let text = Utils.format(value: regularMarketChange) else{ return nil }
        return text.hasPrefix("-") ? text: "+\(text)"
    }
    
    var postPriceText: String?{
        Utils.format(value: postMarketPrice)
    }
    
    var postPriceDiffText: String? {
        guard let text = Utils.format(value: postMarketChange) else { return nil }
        return text.hasPrefix("-") ? text : "+\(text)"
    }
    
    var highText: String{
        Utils.format(value: regularMarketDayHigh) ?? "-"
    }
    
    var openText: String{
        Utils.format(value: regularMarketOpen) ?? "-"
    }
    
    var lowText: String{
        Utils.format(value: regularMarketDayLow) ?? "-"
    }
    
    var volText: String{
        regularMarketVolume?.formatUsingAbbr() ?? "-"
    }
    
    var peText: String{
        Utils.format(value: trailingPE) ?? "-"
    }
    
    var mktCapText: String{
        marketCap?.formatUsingAbbr() ?? "-"
    }
    
    var fiftyTwoWeekHighText: String{
        Utils.format(value: fiftyTwoWeekHigh) ?? "-"
    }
    
    var ffiveTwoWeekLowText: String{
        Utils.format(value: fiftyTwoWeekLow) ?? "-"
    }
    
    var avgVolText: String{
        averageDailyVolume3Month?.formatUsingAbbr() ?? "-"
    }
    
    var yeildText: String{
        "-"
    }
    
    var betaText: String{
        "-"
    }
    
    var epsText: String{
        "-"
    }
    
    var columnItems: [QuoteDetailRowColumnItem]{
        [
            QuoteDetailRowColumnItem(rows:[
                QuoteDetailRowColumnItem.RowItem(title: "Open", value: openText),
                QuoteDetailRowColumnItem.RowItem(title: "High", value: highText),
                QuoteDetailRowColumnItem.RowItem(title: "Low", value: lowText),
            ]),
            QuoteDetailRowColumnItem(rows:[
                QuoteDetailRowColumnItem.RowItem(title: "Vol", value: volText),
                QuoteDetailRowColumnItem.RowItem(title: "P/E", value: peText),
                QuoteDetailRowColumnItem.RowItem(title: "Mkt Cap", value: mktCapText),
            ]),
            QuoteDetailRowColumnItem(rows:[
                QuoteDetailRowColumnItem.RowItem(title: "52W H", value: fiftyTwoWeekHighText),
                QuoteDetailRowColumnItem.RowItem(title: "52W L", value: ffiveTwoWeekLowText),
                QuoteDetailRowColumnItem.RowItem(title: "Avg Vol", value: avgVolText),
            ]),
            QuoteDetailRowColumnItem(rows:[
                QuoteDetailRowColumnItem.RowItem(title: "Yield", value: yeildText),
                QuoteDetailRowColumnItem.RowItem(title: "Beta", value: betaText),
                QuoteDetailRowColumnItem.RowItem(title: "EPS", value: epsText),
            ]),
        ]
    }
}
