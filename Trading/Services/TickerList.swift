//
//  TickerList.swift
//  Trading
//
//  Created by Kaung Zaw Thant on 1/22/25.
//

import Foundation
import ApiStocks

protocol TickerList{
    func save(_ current: [Ticker]) async throws
    func load() async throws -> [Ticker]
}

class TickerPList: TickerList{
    
    private var saved: [Ticker]?
    private let filename: String
    
    private var url:URL{
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appending(component: "\(filename).plist")
    }
    
    init(saved: [Ticker]? = nil, filename: String = "Watchlist") {
        self.saved = saved
        self.filename = filename
    }
    
    func save(_ current: [Ticker]) async throws {
        if let saved,saved == current {
            return
        }
        
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .binary
        let data = try encoder.encode(current)
        try data.write(to: url, options: [.atomic])
        self.saved = current
    }
    
    func load() async throws -> [Ticker] {
        let data = try Data(contentsOf: url)
        let current = try PropertyListDecoder().decode([Ticker].self, from: data)
        self.saved = current
        return current
    }
}
