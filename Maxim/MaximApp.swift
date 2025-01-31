//
//  MaximApp.swift
//  Maxim
//
//  Created by Kaung Zaw Thant on 1/25/25.
//

import SwiftUI
import ApiStocks



@main
struct MaximApp: App {
    let persistenceController = PersistenceController.shared

    @StateObject var appVm = AppViewModel()
    @StateObject var searchVM = SearchViewModel()
    @StateObject var quoteVM = QuoteViewModel()
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


