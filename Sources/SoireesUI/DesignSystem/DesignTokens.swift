import SwiftUI
import UIKit

// MARK: - Design System Soirées Swipe
// Version 1.0 - Juillet 2025
// Palette Dark-mode only selon spécifications

public struct DesignTokens {
    
    // MARK: - Colors Palette
    public struct Colors {
        // Couleurs principales selon spec
        public static let nightBlack = Color(red: 0.043, green: 0.043, blue: 0.055)      // Background global
        public static let neonPink = Color(red: 1.0, green: 0.176, blue: 0.584)        // Accent like & CTA
        public static let neonBlue = Color(red: 0.176, green: 0.976, blue: 1.0)        // Accent secondaire (groupes)
        public static let pureWhite = Color(red: 1.0, green: 1.0, blue: 1.0)       // Texte principal
        public static let gray600 = Color(red: 0.478, green: 0.478, blue: 0.490)         // Sous-titres / séparateurs
        
        // Couleurs dérivées pour l'UI
        public static let backgroundPrimary = nightBlack
        public static let backgroundSecondary = Color(red: 0.067, green: 0.067, blue: 0.082)
        public static let accentPrimary = neonPink
        public static let accentSecondary = neonBlue
        public static let textPrimary = pureWhite
        public static let textSecondary = gray600
        
        // États des boutons
        public static let buttonPrimary = neonPink
        public static let buttonSecondary = neonBlue
        public static let buttonDestructive = Color(hex: "#FF453A")
        
        // États d'interaction
        public static let likeColor = neonPink
        public static let passColor = gray600
        public static let successColor = Color(red: 0.2, green: 0.8, blue: 0.4)
        public static let warningColor = Color(red: 1.0, green: 0.6, blue: 0.0)
        public static let errorColor = Color(red: 0.9, green: 0.2, blue: 0.2)
    }
    
    // MARK: - Typography (SF Pro Rounded)
    public struct Typography {
        // Tailles selon spec
        public static let titleFont = Font.system(size: 28, weight: .bold, design: .rounded)
        public static let headingFont = Font.system(size: 22, weight: .semibold, design: .rounded)
        public static let bodyFont = Font.system(size: 17, weight: .regular, design: .rounded)
        public static let captionFont = Font.system(size: 15, weight: .regular, design: .rounded)
        
        // Variantes utiles
        public static let largeTitleFont = Font.system(size: 34, weight: .bold, design: .rounded)
        public static let subheadlineFont = Font.system(size: 15, weight: .medium, design: .rounded)
        public static let footnoteFont = Font.system(size: 13, weight: .regular, design: .rounded)
        public static let calloutFont = Font.system(size: 16, weight: .medium, design: .rounded)
    }
    
    // MARK: - Spacing (multiples de 4)
    public struct Spacing {
        public static let xxs: CGFloat = 4
        public static let xs: CGFloat = 8
        public static let sm: CGFloat = 12
        public static let md: CGFloat = 16
        public static let lg: CGFloat = 24
        public static let xl: CGFloat = 32
        public static let xxl: CGFloat = 48
        public static let xxxl: CGFloat = 64
        
        // Spacings spécifiques
        public static let cardPadding: CGFloat = md
        public static let sectionSpacing: CGFloat = lg
        public static let elementSpacing: CGFloat = sm
    }
    
    // MARK: - Corner Radius
    public struct Radius {
        public static let card: CGFloat = 20        // Cards selon spec
        public static let button: CGFloat = 12      // Boutons selon spec
        public static let small: CGFloat = 8
        public static let medium: CGFloat = 16
        public static let large: CGFloat = 24
        public static let pill: CGFloat = 100       // Pour boutons pill
    }
    
    // MARK: - Shadows & Effects
    public struct Shadow {
        public static let card = Shadow(
            color: Color.black.opacity(0.3),
            radius: 8,
            x: 0,
            y: 4
        )
        
        public static let button = Shadow(
            color: Color.black.opacity(0.2),
            radius: 4,
            x: 0,
            y: 2
        )
        
        public static let overlay = Shadow(
            color: Color.black.opacity(0.5),
            radius: 12,
            x: 0,
            y: 8
        )
    }
    
    // MARK: - Animation Specs
    public struct Animation {
        // Animations selon spec : Spring & InteractiveSpring
        public static let cardSwipe = SwiftUI.Animation.interactiveSpring(
            response: 0.35,
            dampingFraction: 0.7
        )
        
        public static let standardSpring = SwiftUI.Animation.spring(
            response: 0.4,
            dampingFraction: 0.8
        )
        
        public static let quickSpring = SwiftUI.Animation.spring(
            response: 0.2,
            dampingFraction: 0.9
        )
        
        public static let fadeInOut = SwiftUI.Animation.easeInOut(duration: 0.3)
        public static let scaleEffect = SwiftUI.Animation.easeOut(duration: 0.2)
        
        // Timings selon spec : InteractiveSpring (response: 0.35, damping: 0.7)
        public static let interactiveSpring = SwiftUI.Animation.interactiveSpring(
            response: 0.35,
            dampingFraction: 0.7
        )
        
        // Animations personnalisées
        public static let standardSpring = SwiftUI.Animation.spring(
            response: 0.4,
            dampingFraction: 0.8
        )
        
        public static let cardSwipe = SwiftUI.Animation.spring(
            response: 0.35,
            dampingFraction: 0.7
        )
        
        public static let springBounce = SwiftUI.Animation.spring(
            response: 0.3,
            dampingFraction: 0.6
        )
        
        public static let fadeInOut = SwiftUI.Animation.easeInOut(duration: 0.25)
        
        // Animation personnalisée pour le scrolling
        public static let smoothScroll = SwiftUI.Animation.easeOut(duration: 0.6)
    }
    
    // MARK: - Z-Index Layers
    public struct ZIndex {
        public static let background: Double = 0
        public static let content: Double = 1
        public static let card: Double = 2
        public static let overlay: Double = 3
        public static let navigation: Double = 4
        public static let modal: Double = 5
        public static let alert: Double = 6
        public static let debug: Double = 999
    }
    
    // MARK: - Swipe Thresholds
    public struct SwipeThresholds {
        public static let actionThreshold: CGFloat = 120  // Seuil 120pt selon spec
        public static let previewThreshold: CGFloat = 40   // Badge fade in
        public static let maxRotation: Double = 5          // Rotation ±5° selon spec
        public static let cardScale: (background: CGFloat, middle: CGFloat, top: CGFloat) = (0.94, 0.97, 1.0)
    }
    
    // MARK: - Haptic Feedback
    public struct Haptics {
        public static let light = UIImpactFeedbackGenerator(style: .light)
        public static let medium = UIImpactFeedbackGenerator(style: .medium)
        public static let heavy = UIImpactFeedbackGenerator(style: .heavy)
        public static let success = UINotificationFeedbackGenerator()
        public static let selection = UISelectionFeedbackGenerator()
    }
}

// MARK: - Color Extension pour Hex
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Shadow Helper Struct
public struct Shadow {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

// MARK: - View Modifiers pour Design System
public extension View {
    // Style de carte standard
    func cardStyle() -> some View {
        self
            .background(DesignTokens.Colors.backgroundSecondary)
            .clipShape(RoundedRectangle(cornerRadius: DesignTokens.Radius.card))
            .shadow(
                color: DesignTokens.Shadow.card.color,
                radius: DesignTokens.Shadow.card.radius,
                x: DesignTokens.Shadow.card.x,
                y: DesignTokens.Shadow.card.y
            )
    }
    
    // Style de bouton primaire
    func primaryButtonStyle() -> some View {
        self
            .font(DesignTokens.Typography.headingFont)
            .foregroundStyle(DesignTokens.Colors.pureWhite)
            .padding(.horizontal, DesignTokens.Spacing.lg)
            .padding(.vertical, DesignTokens.Spacing.md)
            .background(DesignTokens.Colors.accentPrimary)
            .clipShape(RoundedRectangle(cornerRadius: DesignTokens.Radius.button))
    }
    
    // Style de bouton secondaire
    func secondaryButtonStyle() -> some View {
        self
            .font(DesignTokens.Typography.headingFont)
            .foregroundStyle(DesignTokens.Colors.accentSecondary)
            .padding(.horizontal, DesignTokens.Spacing.lg)
            .padding(.vertical, DesignTokens.Spacing.md)
            .background(DesignTokens.Colors.backgroundSecondary)
            .clipShape(RoundedRectangle(cornerRadius: DesignTokens.Radius.button))
            .overlay(
                RoundedRectangle(cornerRadius: DesignTokens.Radius.button)
                    .stroke(DesignTokens.Colors.accentSecondary, lineWidth: 1)
            )
    }
} 