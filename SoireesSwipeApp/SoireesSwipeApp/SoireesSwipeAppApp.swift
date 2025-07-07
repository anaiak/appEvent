//
//  SoireesSwipeAppApp.swift
//  SoireesSwipeApp
//
//  Created on 2025.
//

import SwiftUI
import UIKit
import SoireesUI

@main
struct SoireesSwipeAppApp: App {
    
    init() {
        // Configuration de l'application selon Design System
        setupAppearance()
    }
    
    var body: some Scene {
        WindowGroup {
            MainAppView()
                .preferredColorScheme(.dark) // Dark-mode only selon spec
                .background(DesignTokens.Colors.nightBlack)
        }
    }
    
    private func setupAppearance() {
        // Configuration Navigation Bar selon Design System
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(DesignTokens.Colors.nightBlack)
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor(DesignTokens.Colors.pureWhite),
            .font: UIFont.systemFont(ofSize: 22, weight: .semibold)
        ]
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor(DesignTokens.Colors.pureWhite),
            .font: UIFont.systemFont(ofSize: 34, weight: .bold)
        ]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        // Configuration Tab Bar si nécessaire plus tard
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor(DesignTokens.Colors.nightBlack)
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
}

// MARK: - Main App View
struct MainAppView: View {
    @State private var hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
    
    var body: some View {
        Group {
            if hasCompletedOnboarding {
                // Vue principale de swipe
                SwipeView()
            } else {
                // Onboarding flow complet
                OnboardingView(onComplete: {
                    withAnimation(DesignTokens.Animation.standardSpring) {
                        hasCompletedOnboarding = true
                    }
                })
            }
        }
        .animation(DesignTokens.Animation.standardSpring, value: hasCompletedOnboarding)
    }
}

// MARK: - Preview avec Design System
#Preview("App complète") {
    MainAppView()
        .preferredColorScheme(.dark)
}

#Preview("App - Onboarding") {
    OnboardingView(onComplete: {})
        .preferredColorScheme(.dark)
} 