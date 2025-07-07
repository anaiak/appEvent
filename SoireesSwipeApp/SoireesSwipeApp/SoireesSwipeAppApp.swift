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
    @State private var showOnboarding = false
    @State private var hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
    
    var body: some View {
        Group {
            if hasCompletedOnboarding {
                // Vue principale de swipe
                SwipeView()
            } else {
                // Page d'accueil temporaire en attendant l'onboarding
                WelcomeView(onGetStarted: {
                    hasCompletedOnboarding = true
                    UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
                })
            }
        }
        .animation(DesignTokens.Animation.standardSpring, value: hasCompletedOnboarding)
    }
}

// MARK: - Welcome View (temporaire)
struct WelcomeView: View {
    let onGetStarted: () -> Void
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            // Background global selon Design System
            DesignTokens.Colors.nightBlack
                .ignoresSafeArea()
            
            VStack(spacing: DesignTokens.Spacing.xl) {
                Spacer()
                
                // Logo principal avec animation
                VStack(spacing: DesignTokens.Spacing.lg) {
                    // Icône principale avec effet néon
                    ZStack {
                        // Effet de glow
                        Image(systemName: "party.popper.fill")
                            .font(.system(size: 120))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [
                                        DesignTokens.Colors.neonPink,
                                        DesignTokens.Colors.neonBlue
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .blur(radius: 12)
                            .opacity(0.8)
                        
                        // Icône principale
                        Image(systemName: "party.popper.fill")
                            .font(.system(size: 120))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [
                                        DesignTokens.Colors.neonPink,
                                        DesignTokens.Colors.neonBlue
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }
                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                    .rotationEffect(.degrees(isAnimating ? 5 : -5))
                    .animation(
                        DesignTokens.Animation.cardSwipe.repeatForever(autoreverses: true),
                        value: isAnimating
                    )
                    
                    // Titre principal
                    VStack(spacing: DesignTokens.Spacing.sm) {
                        Text("SoireesSwipe")
                            .font(DesignTokens.Typography.largeTitleFont)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [
                                        DesignTokens.Colors.pureWhite,
                                        DesignTokens.Colors.gray600
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                        
                        Text("Découvrez • Likez • Partagez")
                            .font(DesignTokens.Typography.headingFont)
                            .foregroundStyle(DesignTokens.Colors.neonPink)
                    }
                    
                    // Sous-titre
                    Text("L'app qui révolutionne la découverte de soirées près de chez vous")
                        .font(DesignTokens.Typography.bodyFont)
                        .foregroundStyle(DesignTokens.Colors.gray600)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, DesignTokens.Spacing.xl)
                }
                
                Spacer()
                
                // Features highlights
                VStack(spacing: DesignTokens.Spacing.lg) {
                    FeatureRow(
                        icon: "hand.draw",
                        title: "Swipe pour découvrir",
                        description: "Parcourez les événements d'un simple geste"
                    )
                    
                    FeatureRow(
                        icon: "heart.fill",
                        title: "Likez vos favoris",
                        description: "Sauvegardez les soirées qui vous intéressent"
                    )
                    
                    FeatureRow(
                        icon: "person.3.fill",
                        title: "Partagez avec vos amis",
                        description: "Créez des groupes et planifiez ensemble"
                    )
                }
                .padding(.horizontal, DesignTokens.Spacing.xl)
                
                Spacer()
                
                // Bouton principal
                Button(action: {
                    DesignTokens.Haptics.success.notificationOccurred(.success)
                    onGetStarted()
                }) {
                    HStack {
                        Text("Commencer l'aventure")
                            .font(DesignTokens.Typography.headingFont)
                        Image(systemName: "arrow.right")
                            .font(DesignTokens.Typography.headingFont)
                    }
                    .foregroundStyle(DesignTokens.Colors.pureWhite)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, DesignTokens.Spacing.lg)
                    .padding(.vertical, DesignTokens.Spacing.md)
                    .background(
                        LinearGradient(
                            colors: [
                                DesignTokens.Colors.neonPink,
                                DesignTokens.Colors.neonBlue
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: DesignTokens.Radius.button))
                    .shadow(
                        color: DesignTokens.Colors.neonPink.opacity(0.4),
                        radius: 12,
                        x: 0,
                        y: 6
                    )
                }
                .padding(.horizontal, DesignTokens.Spacing.xl)
                .padding(.bottom, DesignTokens.Spacing.xxl)
            }
            .padding(DesignTokens.Spacing.lg)
        }
        .onAppear {
            withAnimation(DesignTokens.Animation.standardSpring.delay(0.5)) {
                isAnimating = true
            }
        }
    }
}

// MARK: - Feature Row Component
private struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: DesignTokens.Spacing.md) {
            // Icône
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundStyle(DesignTokens.Colors.neonBlue)
                .frame(width: 50, height: 50)
                .background(
                    Circle()
                        .fill(DesignTokens.Colors.backgroundSecondary)
                        .overlay(
                            Circle()
                                .stroke(DesignTokens.Colors.neonBlue.opacity(0.3), lineWidth: 1)
                        )
                )
            
            // Texte
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.xxs) {
                Text(title)
                    .font(DesignTokens.Typography.bodyFont)
                    .foregroundStyle(DesignTokens.Colors.pureWhite)
                
                Text(description)
                    .font(DesignTokens.Typography.captionFont)
                    .foregroundStyle(DesignTokens.Colors.gray600)
                    .lineLimit(2)
            }
            
            Spacer()
        }
    }
}

// MARK: - Preview avec Design System
#Preview("App complète") {
    MainAppView()
        .preferredColorScheme(.dark)
}

#Preview("Welcome Screen") {
    WelcomeView(onGetStarted: {})
        .preferredColorScheme(.dark)
} 