import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

// MARK: - Design System Tokens
// Centralise tous les tokens de design selon les spécifications du mockup

public struct DesignTokens {
    private init() {}
    
    // MARK: - Colors
    public struct Colors {
        // Couleurs principales selon spec
        public static let nightBlack = Color(hex: "#0A0A0A")       // Background principal
        public static let pureWhite = Color(hex: "#FFFFFF")        // Texte principal
        public static let accentPrimary = Color(hex: "#FF1B7C")    // Rose néon (NeonPink)
        public static let accentSecondary = Color(hex: "#00F5E4")  // Bleu néon (NeonBlue)
        
        // Couleurs système
        public static let backgroundPrimary = nightBlack
        public static let backgroundSecondary = Color(hex: "#1A1A1A")
        public static let backgroundTertiary = Color(hex: "#2A2A2A")
        
        // Couleurs de texte
        public static let textPrimary = pureWhite
        public static let textSecondary = Color(hex: "#B3B3B3")
        public static let textTertiary = Color(hex: "#666666")
        
        // Couleurs fonctionnelles
        public static let success = Color(hex: "#00FF88")
        public static let warning = Color(hex: "#FFAA00")
        public static let error = Color(hex: "#FF3366")
        
        // Couleurs avec opacité pour overlays
        public static let overlay = Color.black.opacity(0.6)
        public static let cardOverlay = Color.black.opacity(0.3)
    }
    
    // MARK: - Typography
    public struct Typography {
        // Utilise SF Pro Rounded selon spec
        public static let headingFont = Font.system(size: 24, weight: .bold, design: .rounded)
        public static let titleFont = Font.system(size: 20, weight: .semibold, design: .rounded)
        public static let bodyFont = Font.system(size: 16, weight: .medium, design: .rounded)
        public static let captionFont = Font.system(size: 14, weight: .regular, design: .rounded)
        public static let smallFont = Font.system(size: 12, weight: .regular, design: .rounded)
        
        // Tailles de police
        public struct FontSize {
            public static let xxs: CGFloat = 10
            public static let xs: CGFloat = 12
            public static let sm: CGFloat = 14
            public static let md: CGFloat = 16
            public static let lg: CGFloat = 18
            public static let xl: CGFloat = 20
            public static let xxl: CGFloat = 24
            public static let xxxl: CGFloat = 32
        }
    }
    
    // MARK: - Spacing
    public struct Spacing {
        public static let xs: CGFloat = 4
        public static let sm: CGFloat = 8
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
    public struct Shadows {
        public static let card = ShadowStyle(
            color: Color.black.opacity(0.3),
            radius: 8,
            x: 0,
            y: 4
        )
        
        public static let button = ShadowStyle(
            color: Color.black.opacity(0.2),
            radius: 4,
            x: 0,
            y: 2
        )
        
        public static let overlay = ShadowStyle(
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
        
        public static let springBounce = SwiftUI.Animation.spring(
            response: 0.3,
            dampingFraction: 0.6
        )
        
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
        #if canImport(UIKit)
        public static let light = UIImpactFeedbackGenerator(style: .light)
        public static let medium = UIImpactFeedbackGenerator(style: .medium)
        public static let heavy = UIImpactFeedbackGenerator(style: .heavy)
        public static let success = UINotificationFeedbackGenerator()
        public static let selection = UISelectionFeedbackGenerator()
        
        public static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) -> UIImpactFeedbackGenerator {
            return UIImpactFeedbackGenerator(style: style)
        }
        #else
        // Fallback pour macOS/autres plateformes - pas de haptics
        public struct MockHaptic {
            public func impactOccurred() {}
            public func selectionChanged() {}
            public func notificationOccurred(_ type: Int) {}
        }
        
        public static let light = MockHaptic()
        public static let medium = MockHaptic()
        public static let heavy = MockHaptic()
        public static let success = MockHaptic()
        public static let selection = MockHaptic()
        
        public static func impact(_ style: Int) -> MockHaptic {
            return MockHaptic()
        }
        #endif
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
public struct ShadowStyle {
    public let color: Color
    public let radius: CGFloat
    public let x: CGFloat
    public let y: CGFloat
    
    public init(color: Color, radius: CGFloat, x: CGFloat, y: CGFloat) {
        self.color = color
        self.radius = radius
        self.x = x
        self.y = y
    }
}

// MARK: - View Modifiers pour Design System
public extension View {
    // Style de carte standard
    func cardStyle() -> some View {
        self
            .background(DesignTokens.Colors.backgroundSecondary)
            .clipShape(RoundedRectangle(cornerRadius: DesignTokens.Radius.card))
            .shadow(
                color: DesignTokens.Shadows.card.color,
                radius: DesignTokens.Shadows.card.radius,
                x: DesignTokens.Shadows.card.x,
                y: DesignTokens.Shadows.card.y
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