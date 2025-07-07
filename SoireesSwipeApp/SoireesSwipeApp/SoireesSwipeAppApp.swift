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
        // Configuration basique
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark) // Force le mode sombre
        }
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "party.popper")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("SoireesSwipeApp")
                .font(.title)
                .fontWeight(.bold)
            Text("Application de soirées")
                .font(.subtitle)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
    }
}

// MARK: - Preview
#Preview {
    ContentView()
} 