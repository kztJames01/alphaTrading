//
//  MaximApp.swift
//  Maxim
//
//  Created by Kaung Zaw Thant on 1/25/25.
//

import SwiftUI

@main
struct MaximApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
