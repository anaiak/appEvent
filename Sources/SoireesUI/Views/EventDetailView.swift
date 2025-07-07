import SwiftUI
import MapKit

// MARK: - Event Detail View
// Vue détaillée d'un événement avec toutes les informations

public struct EventDetailView: View {
    let event: Event
    @Environment(\.dismiss) private var dismiss
    @State private var showingTicketSheet = false
    @State private var showingShareSheet = false
    @State private var isLiked = false
    @State private var showingVenueMap = false
    
    public init(event: Event) {
        self.event = event
    }
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    // Header Image avec overlay
                    headerImageView
                    
                    // Contenu principal
                    VStack(spacing: DesignTokens.Spacing.lg) {
                        // Info principale
                        mainInfoSection
                        
                        // Tags et genres
                        genresSection
                        
                        // Description
                        descriptionSection
                        
                        // Lineup
                        if !event.lineup.isEmpty {
                            lineupSection
                        }
                        
                        // Venue
                        venueSection
                        
                        // Organisateur
                        organizerSection
                        
                        // Prix et billets
                        ticketSection
                    }
                    .padding(DesignTokens.Spacing.lg)
                }
            }
            .background(DesignTokens.Colors.nightBlack)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(DesignTokens.Colors.pureWhite)
                            .frame(width: 32, height: 32)
                            .background(
                                Circle()
                                    .fill(DesignTokens.Colors.nightBlack.opacity(0.8))
                            )
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: DesignTokens.Spacing.sm) {
                        // Share button
                        Button(action: {
                            showingShareSheet = true
                        }) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(DesignTokens.Colors.pureWhite)
                                .frame(width: 32, height: 32)
                                .background(
                                    Circle()
                                        .fill(DesignTokens.Colors.nightBlack.opacity(0.8))
                                )
                        }
                        
                        // Like button
                        Button(action: {
                            withAnimation(DesignTokens.Animation.springBounce) {
                                isLiked.toggle()
                                DesignTokens.Haptics.light.impactOccurred()
                            }
                        }) {
                            Image(systemName: isLiked ? "heart.fill" : "heart")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(isLiked ? DesignTokens.Colors.neonPink : DesignTokens.Colors.pureWhite)
                                .frame(width: 32, height: 32)
                                .background(
                                    Circle()
                                        .fill(DesignTokens.Colors.nightBlack.opacity(0.8))
                                )
                        }
                    }
                }
            }
            .sheet(isPresented: $showingTicketSheet) {
                TicketPurchaseView(event: event)
            }
            .sheet(isPresented: $showingVenueMap) {
                VenueMapView(venue: event.venue)
            }
        }
    }
    
    // MARK: - Header Image
    private var headerImageView: some View {
        ZStack(alignment: .bottom) {
            AsyncImage(url: URL(string: event.imageURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [
                                DesignTokens.Colors.backgroundSecondary,
                                DesignTokens.Colors.nightBlack
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        Image(systemName: "photo")
                            .font(.system(size: 60))
                            .foregroundStyle(DesignTokens.Colors.gray600)
                    )
            }
            .frame(height: 300)
            .clipped()
            
            // Dégradé overlay
            LinearGradient(
                colors: [
                    Color.clear,
                    Color.clear,
                    DesignTokens.Colors.nightBlack.opacity(0.8)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            
            // Status badge
            HStack {
                Spacer()
                VStack {
                    if event.isToday {
                        StatusBadge(text: "Aujourd'hui", color: DesignTokens.Colors.neonPink)
                    } else if event.isTomorrow {
                        StatusBadge(text: "Demain", color: DesignTokens.Colors.neonBlue)
                    }
                    Spacer()
                }
                .padding(.top, 60)
                .padding(.trailing, DesignTokens.Spacing.lg)
            }
        }
    }
    
    // MARK: - Main Info Section
    private var mainInfoSection: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
            Text(event.title)
                .font(DesignTokens.Typography.largeTitleFont)
                .foregroundStyle(DesignTokens.Colors.pureWhite)
                .lineLimit(3)
            
            HStack(spacing: DesignTokens.Spacing.lg) {
                // Date et heure
                InfoRow(
                    icon: "calendar",
                    title: "Date",
                    value: "\(event.formattedDate) à \(event.formattedTime)",
                    iconColor: DesignTokens.Colors.neonBlue
                )
                
                Spacer()
                
                // Distance
                if !event.formattedDistance.isEmpty {
                    InfoRow(
                        icon: "location",
                        title: "Distance",
                        value: event.formattedDistance,
                        iconColor: DesignTokens.Colors.neonPink
                    )
                }
            }
        }
    }
    
    // MARK: - Genres Section
    private var genresSection: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            Text("Genres musicaux")
                .font(DesignTokens.Typography.headingFont)
                .foregroundStyle(DesignTokens.Colors.pureWhite)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: DesignTokens.Spacing.sm) {
                    ForEach(event.musicGenres, id: \.self) { genre in
                        GenreChip(genre: genre)
                    }
                }
                .padding(.horizontal, 1)
            }
        }
    }
    
    // MARK: - Description Section
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            Text("Description")
                .font(DesignTokens.Typography.headingFont)
                .foregroundStyle(DesignTokens.Colors.pureWhite)
            
            Text(event.description)
                .font(DesignTokens.Typography.bodyFont)
                .foregroundStyle(DesignTokens.Colors.gray600)
                .lineSpacing(4)
        }
    }
    
    // MARK: - Lineup Section
    private var lineupSection: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
            Text("Line-up")
                .font(DesignTokens.Typography.headingFont)
                .foregroundStyle(DesignTokens.Colors.pureWhite)
            
            VStack(spacing: DesignTokens.Spacing.sm) {
                ForEach(event.lineup) { artist in
                    ArtistRow(artist: artist)
                }
            }
        }
    }
    
    // MARK: - Venue Section
    private var venueSection: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
            Text("Lieu")
                .font(DesignTokens.Typography.headingFont)
                .foregroundStyle(DesignTokens.Colors.pureWhite)
            
            Button(action: {
                showingVenueMap = true
            }) {
                HStack(spacing: DesignTokens.Spacing.md) {
                    Image(systemName: "location.circle.fill")
                        .font(.system(size: 40))
                        .foregroundStyle(DesignTokens.Colors.neonBlue)
                    
                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.xxs) {
                        Text(event.venue.name)
                            .font(DesignTokens.Typography.bodyFont)
                            .foregroundStyle(DesignTokens.Colors.pureWhite)
                        
                        Text(event.venue.fullAddress)
                            .font(DesignTokens.Typography.captionFont)
                            .foregroundStyle(DesignTokens.Colors.gray600)
                            .lineLimit(2)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(DesignTokens.Colors.gray600)
                }
                .padding(DesignTokens.Spacing.md)
                .background(DesignTokens.Colors.backgroundSecondary)
                .clipShape(RoundedRectangle(cornerRadius: DesignTokens.Radius.button))
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    // MARK: - Organizer Section
    private var organizerSection: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
            Text("Organisateur")
                .font(DesignTokens.Typography.headingFont)
                .foregroundStyle(DesignTokens.Colors.pureWhite)
            
            HStack(spacing: DesignTokens.Spacing.md) {
                // Avatar placeholder
                Circle()
                    .fill(DesignTokens.Colors.backgroundSecondary)
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(DesignTokens.Colors.gray600)
                    )
                
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.xxs) {
                    HStack(spacing: DesignTokens.Spacing.xs) {
                        Text(event.organizer.name)
                            .font(DesignTokens.Typography.bodyFont)
                            .foregroundStyle(DesignTokens.Colors.pureWhite)
                        
                        if event.organizer.verified {
                            Image(systemName: "checkmark.seal.fill")
                                .font(.system(size: 16))
                                .foregroundStyle(DesignTokens.Colors.successColor)
                        }
                    }
                    
                    if let bio = event.organizer.bio {
                        Text(bio)
                            .font(DesignTokens.Typography.captionFont)
                            .foregroundStyle(DesignTokens.Colors.gray600)
                            .lineLimit(2)
                    }
                }
                
                Spacer()
            }
        }
    }
    
    // MARK: - Ticket Section
    private var ticketSection: some View {
        VStack(spacing: DesignTokens.Spacing.lg) {
            // Prix et disponibilité
            HStack {
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.xxs) {
                    Text("Prix")
                        .font(DesignTokens.Typography.captionFont)
                        .foregroundStyle(DesignTokens.Colors.gray600)
                    
                    Text(event.priceRange)
                        .font(DesignTokens.Typography.titleFont)
                        .foregroundStyle(DesignTokens.Colors.neonBlue)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: DesignTokens.Spacing.xxs) {
                    Text("Disponibilité")
                        .font(DesignTokens.Typography.captionFont)
                        .foregroundStyle(DesignTokens.Colors.gray600)
                    
                    Text(event.ticketInfo.availability.displayText)
                        .font(DesignTokens.Typography.bodyFont)
                        .foregroundStyle(event.ticketInfo.availability.color)
                }
            }
            
            // Bouton d'achat
            Button(action: {
                showingTicketSheet = true
                DesignTokens.Haptics.medium.impactOccurred()
            }) {
                HStack {
                    Image(systemName: "ticket.fill")
                        .font(DesignTokens.Typography.headingFont)
                    Text("Obtenir des billets")
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
            .disabled(event.ticketInfo.availability == .soldOut)
        }
        .padding(.top, DesignTokens.Spacing.lg)
    }
}

// MARK: - Supporting Views

private struct StatusBadge: View {
    let text: String
    let color: Color
    
    var body: some View {
        Text(text)
            .font(DesignTokens.Typography.captionFont)
            .fontWeight(.bold)
            .foregroundStyle(DesignTokens.Colors.pureWhite)
            .padding(.horizontal, DesignTokens.Spacing.sm)
            .padding(.vertical, DesignTokens.Spacing.xs)
            .background(
                color
                    .shadow(color: color.opacity(0.6), radius: 8, x: 0, y: 0)
            )
            .clipShape(RoundedRectangle(cornerRadius: DesignTokens.Radius.small))
    }
}

private struct InfoRow: View {
    let icon: String
    let title: String
    let value: String
    let iconColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xxs) {
            HStack(spacing: DesignTokens.Spacing.xs) {
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundStyle(iconColor)
                Text(title)
                    .font(DesignTokens.Typography.captionFont)
                    .foregroundStyle(DesignTokens.Colors.gray600)
            }
            
            Text(value)
                .font(DesignTokens.Typography.bodyFont)
                .foregroundStyle(DesignTokens.Colors.pureWhite)
        }
    }
}

private struct GenreChip: View {
    let genre: MusicGenre
    
    var body: some View {
        HStack(spacing: DesignTokens.Spacing.xs) {
            Text(genre.emoji)
                .font(.system(size: 14))
            Text(genre.rawValue)
                .font(DesignTokens.Typography.captionFont)
                .foregroundStyle(DesignTokens.Colors.pureWhite)
        }
        .padding(.horizontal, DesignTokens.Spacing.sm)
        .padding(.vertical, DesignTokens.Spacing.xs)
        .background(
            DesignTokens.Colors.neonBlue.opacity(0.2)
                .background(.ultraThinMaterial)
        )
        .clipShape(RoundedRectangle(cornerRadius: DesignTokens.Radius.small))
        .overlay(
            RoundedRectangle(cornerRadius: DesignTokens.Radius.small)
                .stroke(DesignTokens.Colors.neonBlue.opacity(0.5), lineWidth: 1)
        )
    }
}

private struct ArtistRow: View {
    let artist: Artist
    
    var body: some View {
        HStack(spacing: DesignTokens.Spacing.md) {
            // Avatar placeholder
            Circle()
                .fill(DesignTokens.Colors.backgroundSecondary)
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: "music.note")
                        .font(.system(size: 18))
                        .foregroundStyle(DesignTokens.Colors.gray600)
                )
            
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.xxs) {
                HStack(spacing: DesignTokens.Spacing.xs) {
                    Text(artist.name)
                        .font(artist.isHeadliner ? DesignTokens.Typography.headingFont : DesignTokens.Typography.bodyFont)
                        .foregroundStyle(DesignTokens.Colors.pureWhite)
                    
                    if artist.isHeadliner {
                        Text("HEADLINER")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(DesignTokens.Colors.pureWhite)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(DesignTokens.Colors.neonPink)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                    }
                }
                
                if !artist.genres.isEmpty {
                    HStack(spacing: DesignTokens.Spacing.xs) {
                        ForEach(Array(artist.genres.prefix(2)), id: \.self) { genre in
                            Text(genre.rawValue)
                                .font(.system(size: 11))
                                .foregroundStyle(DesignTokens.Colors.gray600)
                        }
                    }
                }
            }
            
            Spacer()
        }
        .padding(.vertical, DesignTokens.Spacing.xs)
    }
}

// MARK: - Placeholder Modal Views

private struct TicketPurchaseView: View {
    let event: Event
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: DesignTokens.Spacing.lg) {
                Text("Achat de billets")
                    .font(DesignTokens.Typography.titleFont)
                    .foregroundStyle(DesignTokens.Colors.pureWhite)
                
                Text("Redirection vers la billetterie...")
                    .font(DesignTokens.Typography.bodyFont)
                    .foregroundStyle(DesignTokens.Colors.gray600)
                
                Spacer()
            }
            .padding(DesignTokens.Spacing.lg)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(DesignTokens.Colors.nightBlack)
            .navigationTitle("Billets")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fermer") {
                        dismiss()
                    }
                    .foregroundStyle(DesignTokens.Colors.neonPink)
                }
            }
        }
    }
}

private struct VenueMapView: View {
    let venue: Venue
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: DesignTokens.Spacing.lg) {
                Text("Carte du lieu")
                    .font(DesignTokens.Typography.titleFont)
                    .foregroundStyle(DesignTokens.Colors.pureWhite)
                
                Text(venue.fullAddress)
                    .font(DesignTokens.Typography.bodyFont)
                    .foregroundStyle(DesignTokens.Colors.gray600)
                    .multilineTextAlignment(.center)
                
                Spacer()
            }
            .padding(DesignTokens.Spacing.lg)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(DesignTokens.Colors.nightBlack)
            .navigationTitle(venue.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fermer") {
                        dismiss()
                    }
                    .foregroundStyle(DesignTokens.Colors.neonPink)
                }
            }
        }
    }
}

// MARK: - Preview
#Preview("Event Detail") {
    EventDetailView(event: Event.mockEvents[0])
        .preferredColorScheme(.dark)
} 