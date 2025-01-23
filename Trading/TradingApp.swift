//
//  TradingApp.swift
//  Trading
//
//  Created by Kaung Zaw Thant on 1/19/25.
//

import SwiftUI
import ApiStocks

@main
struct TradingApp: App {
    let persistenceController = PersistenceController.shared
    let stocks = ApiStocks()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear(){
                    Task{
                        do{
                            let quotes = try await stocks.fetchQuotes(symbol: "AAPL")
                        }catch{
                            print(error.localizedDescription)
                        }
                    }
                }
        }
    }
}
