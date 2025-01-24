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
    
    @StateObject var appVm = AppViewModel()
    var searchVM = SearchViewModel()
    var quoteVM = QuoteViewModel()
    let persistenceController = PersistenceController.shared
    let stocks = ApiStocks()
    var body: some Scene {
        WindowGroup {
            NavigationStack{
                MainView(quotesVM: quoteVM, searchVM: searchVM)
            }
            .environmentObject(appVm)
        }
    }
}
