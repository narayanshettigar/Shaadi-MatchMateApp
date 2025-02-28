//
//  MatchMateApp.swift
//  MatchMakingApp
//
//  Created by Narayan Shettigar on 28/02/25.
//

import SwiftUI

// MARK: - App Entry Point
@main
struct MatchMateApp: App {
    var body: some Scene {
        WindowGroup {
            HomeScreen()
        }
        .modelContainer(for: UserProfile.self)
    }
}
