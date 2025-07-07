//
//  SoireesSwipeAppApp.swift
//  SoireesSwipeApp
//
//  Created on 2025.
//

import SwiftUI

@main
struct SoireesSwipeAppApp: App {
    
    init() {
        // Configuration de l'UI Library
        SoireesUI.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            SoireesUI.makeRootView()
                .preferredColorScheme(.dark) // Force le mode sombre
        }
    }
}

// MARK: - Preview
#Preview {
    SoireesUI.makeRootView()
} 