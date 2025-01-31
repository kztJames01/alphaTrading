//
//  Foundation+Extensions.swift
//  Maxim
//
//  Created by Kaung Zaw Thant on 1/29/25.
//

import Foundation

extension Double {
    
    func formatUsingAbbr () -> String {
        let numFormatter = NumberFormatter()
        
        typealias Abbr = (threshold: Double, divisor: Double, suffix: String)
        let abbrs: [Abbr] = [
            (0,1,""),
            (1000.0, 1000.0, "K"),
            (100_000.0, 1_000_000.0, "M"),
            (100_000_000.0, 1_000_000_000.0, "B"),
            (100_000_000_000.0, 1_000_000_000_000.0, "T"),
        ]
        let startValue = Double(abs(self))
        let abbr: Abbr = {
            var prevAbbr = abbrs[0]
            for tmpAbbr in abbrs{
                if( startValue < tmpAbbr.threshold ){
                    break
                }
                prevAbbr = tmpAbbr
            }
            return prevAbbr
        }()
        
        let value = Double(self) / abbr.divisor
        numFormatter.positiveSuffix = abbr.suffix
        numFormatter.negativeSuffix = abbr.suffix
        numFormatter.allowsFloats = true
        numFormatter.minimumFractionDigits = 0
        numFormatter.minimumIntegerDigits = 1
        numFormatter.maximumFractionDigits = 3
        numFormatter.decimalSeparator = "."
        
        return numFormatter.string(from: NSNumber(value: value)) ?? ""
    }
}
