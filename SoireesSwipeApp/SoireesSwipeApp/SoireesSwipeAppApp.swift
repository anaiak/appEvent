//
//  SoireesSwipeAppApp.swift
//  SoireesSwipeApp
//
//  Created on 2025.
//

import SwiftUI
import UIKit

@main
struct SoireesSwipeAppApp: App {
    
    init() {
        // Configuration de l'application
        setupAppearance()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark) // Force le mode sombre
        }
    }
    
    private func setupAppearance() {
        // Configuration de l'apparence globale de l'app
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.black
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}

struct ContentView: View {
    @State private var isAnimating = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Arrière-plan dégradé moderne
                LinearGradient(
                    colors: [.black, .purple.opacity(0.3), .black],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    // Logo animé
                    Image(systemName: "party.popper.fill")
                        .font(.system(size: 80))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.yellow, .orange, .pink],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .scaleEffect(isAnimating ? 1.1 : 1.0)
                        .rotationEffect(.degrees(isAnimating ? 5 : -5))
                        .animation(
                            .easeInOut(duration: 2.0).repeatForever(autoreverses: true),
                            value: isAnimating
                        )
                    
                    VStack(spacing: 15) {
                        Text("SoireesSwipeApp")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.white, .gray],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                        
                        Text("Découvrez les meilleures soirées près de chez vous")
                            .font(.title3)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    
                    // Boutons d'action modernes
                    VStack(spacing: 20) {
                        Button(action: {
                            // Action pour explorer les soirées
                        }) {
                            HStack {
                                Image(systemName: "magnifyingglass")
                                Text("Explorer les soirées")
                            }
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    colors: [.purple, .pink],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                        }
                        
                        Button(action: {
                            // Action pour voir le profil
                        }) {
                            HStack {
                                Image(systemName: "person.circle.fill")
                                Text("Mon profil")
                            }
                            .font(.headline)
                            .foregroundStyle(.purple)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.regularMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                        }
                    }
                    .padding(.horizontal, 40)
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Accueil")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            isAnimating = true
        }
    }
}

// MARK: - Preview avec nouvelles APIs
#Preview("App principale") {
    ContentView()
}

#Preview("Mode clair") {
    ContentView()
        .preferredColorScheme(.light)
} 