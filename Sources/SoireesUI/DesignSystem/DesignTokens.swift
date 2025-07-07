import SwiftUI

// MARK: - Design Tokens
public struct DesignTokens {
    
    // MARK: - Colors
    public struct Colors {
        public static let nightBlack = Color(hex: "#0B0B0E")
        public static let neonPink = Color(hex: "#FF2D95")
        public static let neonBlue = Color(hex: "#2DF9FF")
        public static let pureWhite = Color(hex: "#FFFFFF")
        public static let gray600 = Color(hex: "#7A7A7D")
    }
    
    // MARK: - Typography
    public struct Typography {
        public static let title = Font.custom("SF Pro Rounded", size: 28).weight(.bold)
        public static let heading = Font.custom("SF Pro Rounded", size: 22).weight(.semibold)
        public static let body = Font.custom("SF Pro Rounded", size: 17).weight(.regular)
        public static let caption = Font.custom("SF Pro Rounded", size: 15).weight(.regular)
    }
    
    // MARK: - Spacing
    public struct Spacing {
        public static let xs: CGFloat = 4
        public static let sm: CGFloat = 8
        public static let md: CGFloat = 12
        public static let lg: CGFloat = 16
        public static let xl: CGFloat = 24
        public static let xxl: CGFloat = 32
    }
    
    // MARK: - Radius
    public struct Radius {
        public static let card: CGFloat = 20
        public static let button: CGFloat = 12
    }
    
    // MARK: - Animations
    public struct Animation {
        public static let spring = SwiftUI.Animation.interactiveSpring(
            response: 0.35,
            dampingFraction: 0.7
        )
        public static let swipeThreshold: CGFloat = 120
        public static let likeThreshold: CGFloat = 40
        
        public struct CardScale {
            public static let background: CGFloat = 0.94
            public static let middle: CGFloat = 0.97
            public static let front: CGFloat = 1.0
        }
    }
}

// MARK: - Color Extension
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