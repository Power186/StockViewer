//
//  StocksApp.swift
//  Stocks
//
//  Created by Scott on 3/2/21.
//

import SwiftUI

@main
struct StocksApp: App {
    let persistenceController = PersistenceController.shared
    @Environment(\.scenePhase) var scenePhase
    
    init() {
        let temporaryDirectory = NSTemporaryDirectory()
        let urlCache = URLCache(memoryCapacity: 150_000_000, diskCapacity: 200_000_000, diskPath: temporaryDirectory)
        URLCache.shared = urlCache
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        .onChange(of: scenePhase) { _ in
            persistenceController.save()
        }
    }
}
