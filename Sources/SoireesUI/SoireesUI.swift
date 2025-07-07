// Soirées Swipe UI Library
// Version 1.0 - Juillet 2025
// Swift Package pour l'interface utilisateur de l'application iOS "Soirées Swipe"

import SwiftUI

// MARK: - Main Views
@_exported import struct SwiftUI.SwipeView
@_exported import struct SwiftUI.EventDetailView
@_exported import struct SwiftUI.ProfileView
@_exported import struct SwiftUI.GroupsView
@_exported import struct SwiftUI.AppSettingsView

// MARK: - Components
@_exported import struct SwiftUI.EventCardView
@_exported import struct SwiftUI.GenreChip
@_exported import struct SwiftUI.SwipeBadge

// MARK: - Models
@_exported import struct Foundation.Event
@_exported import struct Foundation.EventLocation
@_exported import struct Foundation.Artist
@_exported import struct Foundation.Price
@_exported import struct Foundation.Group
@_exported import struct Foundation.User
@_exported import struct Foundation.UserPreferences
@_exported import struct Foundation.GroupInvite
@_exported import struct Foundation.Coordinate

// MARK: - ViewModels
@_exported import class Combine.SwipeViewModel
@_exported import class Combine.GroupsViewModel

// MARK: - Services
@_exported import class Foundation.EventService
@_exported import class CoreLocation.LocationManager
@_exported import class Combine.SessionStore

// MARK: - Design System
@_exported import struct SwiftUI.DesignTokens

// MARK: - Enums
@_exported import enum Foundation.SwipeDirection
@_exported import enum Foundation.SwipeError

// MARK: - Public API
public struct SoireesUI {
    
    /// Version de la librairie
    public static let version = "1.0.0"
    
    /// Configuration de l'application
    public static func configure() {
        // Configuration globale si nécessaire
        setupAppearance()
    }
    
    /// Configuration de l'apparence globale
    private static func setupAppearance() {
        // Configuration des couleurs d'accent globales
        UIView.appearance().tintColor = UIColor(DesignTokens.Colors.neonPink)
        
        // Configuration de la navigation bar
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = UIColor(DesignTokens.Colors.nightBlack)
        navBarAppearance.titleTextAttributes = [
            .foregroundColor: UIColor(DesignTokens.Colors.pureWhite),
            .font: UIFont.systemFont(ofSize: 22, weight: .semibold)
        ]
        navBarAppearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor(DesignTokens.Colors.pureWhite),
            .font: UIFont.systemFont(ofSize: 28, weight: .bold)
        ]
        
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        UINavigationBar.appearance().compactAppearance = navBarAppearance
        
        // Configuration du tab bar (si utilisé)
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor(DesignTokens.Colors.nightBlack)
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
    
    /// Point d'entrée principal de l'application
    public static func makeRootView() -> some View {
        SwipeView()
            .environmentObject(SessionStore())
            .preferredColorScheme(.dark) // Force le mode sombre
    }
}

// MARK: - Convenience Extensions
extension Color {
    /// Couleurs du design system pour un accès rapide
    public struct Soirees {
        public static let nightBlack = DesignTokens.Colors.nightBlack
        public static let neonPink = DesignTokens.Colors.neonPink
        public static let neonBlue = DesignTokens.Colors.neonBlue
        public static let pureWhite = DesignTokens.Colors.pureWhite
        public static let gray600 = DesignTokens.Colors.gray600
    }
}

extension Font {
    /// Typographie du design system pour un accès rapide
    public struct Soirees {
        public static let title = DesignTokens.Typography.title
        public static let heading = DesignTokens.Typography.heading
        public static let body = DesignTokens.Typography.body
        public static let caption = DesignTokens.Typography.caption
    }
}

// MARK: - SwiftUI Preview Helpers
#if DEBUG
public struct SoireesPreviews {
    
    /// Événement de démonstration pour les previews
    public static let mockEvent = Event(
        title: "Techno Night à La Bellevilloise",
        description: "Une soirée techno inoubliable avec des DJs internationaux dans le cadre mythique de La Bellevilloise.",
        imageURL: URL(string: "https://example.com/event.jpg"),
        date: Date().addingTimeInterval(3600 * 24 * 2),
        location: EventLocation(
            name: "La Bellevilloise",
            address: "19-21 Rue Boyer",
            city: "Paris",
            coordinate: Coordinate(latitude: 48.8566, longitude: 2.3522)
        ),
        lineup: [
            Artist(name: "Charlotte de Witte", genre: "Techno"),
            Artist(name: "Amelie Lens", genre: "Techno")
        ],
        genres: ["Techno", "Electronic"],
        price: Price(amount: 25.0),
        ticketURL: URL(string: "https://example.com/tickets"),
        distance: 2.3
    )
    
    /// Session store de démonstration pour les previews
    public static let mockSessionStore = SessionStore()
    
    /// Configuration pour les previews avec le theme sombre
    public static func darkPreview<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        content()
            .preferredColorScheme(.dark)
            .background(DesignTokens.Colors.nightBlack)
    }
}
#endif 