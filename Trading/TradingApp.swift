//
//  TradingApp.swift
//  Trading
//
//  Created by Kaung Zaw Thant on 1/19/25.
//

import SwiftUI

@main
struct TradingApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
