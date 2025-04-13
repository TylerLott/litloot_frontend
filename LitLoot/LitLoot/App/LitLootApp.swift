//
//  LitLootApp.swift
//  LitLoot
//
//  Created by Tyler Lott on 4/12/25.
//

import SwiftUI

@main
struct LitLootApp: App {
    @StateObject var appState = AppState()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(appState)
        }
    }
}

