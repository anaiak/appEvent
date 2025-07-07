import SwiftUI

// MARK: - Event Card View
public struct EventCardView: View {
    let event: Event
    let dragOffset: CGSize
    let rotation: Double
    let likeOpacity: Double
    let passOpacity: Double
    let scale: CGFloat
    
    public init(
        event: Event,
        dragOffset: CGSize = .zero,
        rotation: Double = 0,
        likeOpacity: Double = 0,
        passOpacity: Double = 0,
        scale: CGFloat = 1.0
    ) {
        self.event = event
        self.dragOffset = dragOffset
        self.rotation = rotation
        self.likeOpacity = likeOpacity
        self.passOpacity = passOpacity
        self.scale = scale
    }
    
    public var body: some View {
        ZStack {
            // Image de fond
            AsyncImage(url: event.imageURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(DesignTokens.Colors.gray600.opacity(0.3))
                    .overlay(
                        Image(systemName: "photo")
                            .font(.system(size: 40))
                            .foregroundColor(DesignTokens.Colors.gray600)
                    )
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipped()
            
            // Dégradé overlay
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: .clear, location: 0.0),
                    .init(color: .clear, location: 0.4),
                    .init(color: DesignTokens.Colors.nightBlack.opacity(0.8), location: 1.0)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            
            // Contenu de la carte
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
                Spacer()
                
                // Informations de l'événement
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                    // Titre
                    Text(event.title)
                        .font(DesignTokens.Typography.heading)
                        .foregroundColor(DesignTokens.Colors.pureWhite)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    // Date et distance
                    HStack(spacing: DesignTokens.Spacing.sm) {
                        HStack(spacing: DesignTokens.Spacing.xs) {
                            Image(systemName: "calendar")
                                .font(.caption)
                            Text(event.formattedDate)
                                .font(DesignTokens.Typography.caption)
                        }
                        
                        if let distance = event.formattedDistance {
                            HStack(spacing: DesignTokens.Spacing.xs) {
                                Image(systemName: "location")
                                    .font(.caption)
                                Text(distance)
                                    .font(DesignTokens.Typography.caption)
                            }
                        }
                        
                        Spacer()
                    }
                    .foregroundColor(DesignTokens.Colors.pureWhite.opacity(0.8))
                    
                    // Lieu
                    Text(event.location.name)
                        .font(DesignTokens.Typography.body)
                        .foregroundColor(DesignTokens.Colors.pureWhite.opacity(0.9))
                    
                    // Genres
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: DesignTokens.Spacing.sm) {
                            ForEach(event.genres, id: \.self) { genre in
                                GenreChip(text: genre)
                            }
                        }
                        .padding(.horizontal, 1)
                    }
                    
                    // Prix
                    if let price = event.price {
                        Text(price.formatted)
                            .font(DesignTokens.Typography.heading)
                            .foregroundColor(DesignTokens.Colors.neonPink)
                    }
                }
                .padding(DesignTokens.Spacing.xl)
            }
            
            // Badge Like
            if likeOpacity > 0 {
                SwipeBadge(type: .like, opacity: likeOpacity)
                    .position(x: UIScreen.main.bounds.width * 0.75, y: 100)
            }
            
            // Badge Pass
            if passOpacity > 0 {
                SwipeBadge(type: .pass, opacity: passOpacity)
                    .position(x: UIScreen.main.bounds.width * 0.25, y: 100)
            }
        }
        .background(DesignTokens.Colors.nightBlack)
        .cornerRadius(DesignTokens.Radius.card)
        .scaleEffect(scale)
        .offset(dragOffset)
        .rotationEffect(.degrees(rotation))
        .shadow(
            color: DesignTokens.Colors.nightBlack.opacity(0.3),
            radius: 10,
            x: 0,
            y: 5
        )
    }
}

// MARK: - Genre Chip
struct GenreChip: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(DesignTokens.Typography.caption)
            .foregroundColor(DesignTokens.Colors.pureWhite)
            .padding(.horizontal, DesignTokens.Spacing.md)
            .padding(.vertical, DesignTokens.Spacing.xs)
            .background(
                RoundedRectangle(cornerRadius: DesignTokens.Radius.button)
                    .fill(DesignTokens.Colors.neonBlue.opacity(0.2))
                    .overlay(
                        RoundedRectangle(cornerRadius: DesignTokens.Radius.button)
                            .stroke(DesignTokens.Colors.neonBlue, lineWidth: 1)
                    )
            )
    }
}

// MARK: - Swipe Badge
struct SwipeBadge: View {
    enum BadgeType {
        case like
        case pass
        
        var color: Color {
            switch self {
            case .like:
                return DesignTokens.Colors.neonPink
            case .pass:
                return DesignTokens.Colors.gray600
            }
        }
        
        var icon: String {
            switch self {
            case .like:
                return "heart.fill"
            case .pass:
                return "xmark"
            }
        }
        
        var text: String {
            switch self {
            case .like:
                return "LIKE"
            case .pass:
                return "PASS"
            }
        }
    }
    
    let type: BadgeType
    let opacity: Double
    
    var body: some View {
        VStack(spacing: DesignTokens.Spacing.sm) {
            Image(systemName: type.icon)
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(type.color)
            
            Text(type.text)
                .font(DesignTokens.Typography.heading)
                .fontWeight(.bold)
                .foregroundColor(type.color)
        }
        .padding(DesignTokens.Spacing.xl)
        .background(
            RoundedRectangle(cornerRadius: DesignTokens.Radius.card)
                .fill(DesignTokens.Colors.pureWhite)
                .shadow(
                    color: type.color.opacity(0.3),
                    radius: 10,
                    x: 0,
                    y: 5
                )
        )
        .opacity(opacity)
        .scaleEffect(0.8 + (opacity * 0.2)) // Animation de scale basée sur l'opacité
    }
}

// MARK: - Previews
#Preview {
    EventCardView(
        event: Event(
            title: "Techno Night à La Bellevilloise",
            description: "Une soirée techno inoubliable",
            imageURL: URL(string: "https://example.com/event.jpg"),
            date: Date().addingTimeInterval(3600 * 24),
            location: EventLocation(
                name: "La Bellevilloise",
                address: "19-21 Rue Boyer",
                city: "Paris",
                coordinate: Coordinate(latitude: 48.8566, longitude: 2.3522)
            ),
            lineup: [
                Artist(name: "Charlotte de Witte", genre: "Techno")
            ],
            genres: ["Techno", "Electronic"],
            price: Price(amount: 25.0),
            ticketURL: URL(string: "https://example.com/tickets"),
            distance: 2.3
        ),
        likeOpacity: 0.5
    )
    .frame(width: 350, height: 600)
    .background(DesignTokens.Colors.nightBlack)
} 