// Soirées Swipe UI Library
// Version 1.0 - Juillet 2025
// Swift Package pour l'interface utilisateur de l'application iOS "Soirées Swipe"

import SwiftUI
import Foundation
import Combine
import CoreLocation
#if canImport(UIKit)
import UIKit
#endif

// MARK: - Module Entry Point
// Point d'entrée principal du module SoireesUI

public struct SoireesUI {
    private init() {}
    
    /// Configure l'apparence globale de l'application
    public static func configureAppearance() {
        #if canImport(UIKit)
        // Configuration de l'apparence UIKit
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor(DesignTokens.Colors.backgroundPrimary)
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor(DesignTokens.Colors.textPrimary),
            .font: UIFont.systemFont(ofSize: 18, weight: .semibold)
        ]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        // Configuration TabBar
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithTransparentBackground()
        tabBarAppearance.backgroundColor = UIColor(DesignTokens.Colors.backgroundPrimary)
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        
        // Couleur d'accent globale
        UIView.appearance().tintColor = UIColor(DesignTokens.Colors.accentPrimary)
        #endif
    }
}

// MARK: - Convenience Extensions
public extension Color {
    /// Couleurs d'accent rapides
    static let neonPink = DesignTokens.Colors.accentPrimary
    static let neonBlue = DesignTokens.Colors.accentSecondary
    static let nightBlack = DesignTokens.Colors.backgroundPrimary
    static let soireesGray = DesignTokens.Colors.textSecondary
}

// MARK: - Typography Extensions  
public extension Font {
    /// Typographies prédéfinies
    static let soireesTitle = DesignTokens.Typography.titleLarge
    static let soireesHeading = DesignTokens.Typography.titleMedium
    static let soireesBody = DesignTokens.Typography.bodyMedium
    static let soireesCaption = DesignTokens.Typography.bodySmall
}

// MARK: - Mock Data
public extension Event {
    /// Exemple d'événement pour les previews et tests
    static let preview = Event(
        id: UUID(),
        title: "Techno Underground",
        description: "Une nuit électrisante dans les souterrains de Paris avec les meilleurs DJs de la scène techno française.",
        imageURL: "https://picsum.photos/400/600?random=1",
        date: Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date(),
        venue: Venue(
            name: "Club Concrete",
            address: "Port de la Gare, Quai François Mauriac",
            city: "Paris",
            postalCode: "75013",
            coordinate: Coordinate(latitude: 48.8283, longitude: 2.3609),
            distance: 2.4
        ),
        organizer: Organizer(name: "Concrete Events", verified: true),
        musicGenres: [.techno, .house],
        ticketInfo: TicketInfo(minPrice: 25, maxPrice: 35),
        lineup: [
            Artist(name: "Boris Brejcha", genres: [.techno]),
            Artist(name: "Charlotte de Witte", genres: [.techno])
        ],
        ageRestriction: .eighteenPlus,
        attendeeCount: 850
    )
}

// MARK: - SwiftUI Preview Helpers
#if DEBUG
public struct SoireesPreviews {
    
    /// Événement de démonstration pour les previews
    @MainActor
    public static let mockEvent = Event(
        id: UUID(),
        title: "Techno Night à La Bellevilloise",
        description: "Une soirée techno inoubliable avec des DJs internationaux dans le cadre mythique de La Bellevilloise.",
        imageURL: "https://example.com/event.jpg",
        date: Date().addingTimeInterval(3600 * 24 * 2),
        venue: Venue(
            name: "La Bellevilloise",
            address: "19-21 Rue Boyer",
            city: "Paris",
            postalCode: "75020",
            coordinate: Coordinate(latitude: 48.8566, longitude: 2.3522),
            distance: 2.3
        ),
        organizer: Organizer(
            name: "La Bellevilloise",
            verified: true
        ),
        musicGenres: [.techno, .electronic],
        ticketInfo: TicketInfo(
            minPrice: 25.0,
            maxPrice: 35.0
        ),
        lineup: [
            Artist(name: "Charlotte de Witte", genres: [.techno]),
            Artist(name: "Amelie Lens", genres: [.techno])
        ],
        ageRestriction: .eighteenPlus,
        attendeeCount: 150
    )
    
    /// Configuration pour les previews avec le theme sombre
    public static func darkPreview<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        content()
            .preferredColorScheme(.dark)
            .background(DesignTokens.Colors.backgroundPrimary)
    }
}
#endif 