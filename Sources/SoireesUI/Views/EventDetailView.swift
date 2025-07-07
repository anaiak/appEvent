import SwiftUI
import MapKit

// MARK: - Event Detail View
public struct EventDetailView: View {
    let event: Event
    @EnvironmentObject private var sessionStore: SessionStore
    @Environment(\.dismiss) private var dismiss
    @State private var showingGroupSelector = false
    @State private var selectedGroup: Group?
    
    public init(event: Event) {
        self.event = event
    }
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Header Image avec Parallax
                headerImageView
                
                // Contenu détaillé
                contentView
                    .background(DesignTokens.Colors.nightBlack)
            }
        }
        .background(DesignTokens.Colors.nightBlack)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Fermer") {
                    dismiss()
                }
                .foregroundColor(DesignTokens.Colors.pureWhite)
            }
        }
        .sheet(isPresented: $showingGroupSelector) {
            GroupSelectorView(event: event, selectedGroup: $selectedGroup)
                .environmentObject(sessionStore)
        }
    }
    
    // MARK: - Header Image View
    private var headerImageView: some View {
        GeometryReader { geometry in
            let offset = geometry.frame(in: .global).minY
            let height = geometry.size.height + max(0, offset)
            
            AsyncImage(url: event.imageURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: height)
                    .offset(y: -max(0, offset))
            } placeholder: {
                Rectangle()
                    .fill(DesignTokens.Colors.gray600)
                    .frame(width: geometry.size.width, height: height)
                    .overlay(
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: DesignTokens.Colors.pureWhite))
                    )
            }
            .clipped()
            .overlay(
                // Dégradé overlay
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: .clear, location: 0.6),
                        .init(color: DesignTokens.Colors.nightBlack, location: 1.0)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        }
        .frame(height: 300)
    }
    
    // MARK: - Content View
    private var contentView: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xl) {
            // Titre et infos principales
            eventHeaderSection
            
            // Description
            if !event.description.isEmpty {
                descriptionSection
            }
            
            // Line-up
            if !event.lineup.isEmpty {
                lineupSection
            }
            
            // Localisation
            locationSection
            
            // Actions
            actionSection
            
            Spacer(minLength: DesignTokens.Spacing.xxl)
        }
        .padding(.horizontal, DesignTokens.Spacing.xl)
        .padding(.top, -DesignTokens.Spacing.lg) // Overlap avec l'image
    }
    
    // MARK: - Event Header Section
    private var eventHeaderSection: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
            Text(event.title)
                .font(DesignTokens.Typography.title)
                .foregroundColor(DesignTokens.Colors.pureWhite)
                .multilineTextAlignment(.leading)
            
            HStack(spacing: DesignTokens.Spacing.lg) {
                HStack(spacing: DesignTokens.Spacing.sm) {
                    Image(systemName: "calendar")
                        .foregroundColor(DesignTokens.Colors.neonPink)
                    Text(event.formattedDate)
                        .font(DesignTokens.Typography.body)
                        .foregroundColor(DesignTokens.Colors.pureWhite)
                }
                
                if let distance = event.formattedDistance {
                    HStack(spacing: DesignTokens.Spacing.sm) {
                        Image(systemName: "location")
                            .foregroundColor(DesignTokens.Colors.neonBlue)
                        Text(distance)
                            .font(DesignTokens.Typography.body)
                            .foregroundColor(DesignTokens.Colors.pureWhite)
                    }
                }
                
                Spacer()
                
                if let price = event.price {
                    Text(price.formatted)
                        .font(DesignTokens.Typography.heading)
                        .foregroundColor(DesignTokens.Colors.neonPink)
                }
            }
            
            // Genres
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: DesignTokens.Spacing.sm) {
                    ForEach(event.genres, id: \.self) { genre in
                        GenreChip(text: genre)
                    }
                }
                .padding(.horizontal, 1)
            }
        }
    }
    
    // MARK: - Description Section
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
            Text("Description")
                .font(DesignTokens.Typography.heading)
                .foregroundColor(DesignTokens.Colors.pureWhite)
            
            Text(event.description)
                .font(DesignTokens.Typography.body)
                .foregroundColor(DesignTokens.Colors.pureWhite.opacity(0.8))
                .lineSpacing(4)
        }
    }
    
    // MARK: - Lineup Section
    private var lineupSection: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
            Text("Line-up")
                .font(DesignTokens.Typography.heading)
                .foregroundColor(DesignTokens.Colors.pureWhite)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: DesignTokens.Spacing.md) {
                ForEach(event.lineup) { artist in
                    ArtistCard(artist: artist)
                }
            }
        }
    }
    
    // MARK: - Location Section
    private var locationSection: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
            Text("Lieu")
                .font(DesignTokens.Typography.heading)
                .foregroundColor(DesignTokens.Colors.pureWhite)
            
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                Text(event.location.name)
                    .font(DesignTokens.Typography.body)
                    .fontWeight(.semibold)
                    .foregroundColor(DesignTokens.Colors.pureWhite)
                
                Text("\(event.location.address), \(event.location.city)")
                    .font(DesignTokens.Typography.caption)
                    .foregroundColor(DesignTokens.Colors.gray600)
            }
            
            // Carte snapshot (simplifié)
            RoundedRectangle(cornerRadius: DesignTokens.Radius.button)
                .fill(DesignTokens.Colors.gray600.opacity(0.3))
                .frame(height: 120)
                .overlay(
                    VStack {
                        Image(systemName: "map")
                            .font(.system(size: 24))
                            .foregroundColor(DesignTokens.Colors.neonBlue)
                        Text("Voir sur la carte")
                            .font(DesignTokens.Typography.caption)
                            .foregroundColor(DesignTokens.Colors.neonBlue)
                    }
                )
        }
    }
    
    // MARK: - Action Section
    private var actionSection: some View {
        VStack(spacing: DesignTokens.Spacing.lg) {
            // Bouton ajouter au groupe
            Button(action: {
                showingGroupSelector = true
            }) {
                HStack {
                    Image(systemName: "person.3.fill")
                        .font(.system(size: 18))
                    Text("Ajouter au groupe")
                        .font(DesignTokens.Typography.body)
                        .fontWeight(.semibold)
                }
                .foregroundColor(DesignTokens.Colors.pureWhite)
                .frame(maxWidth: .infinity)
                .padding(.vertical, DesignTokens.Spacing.lg)
                .background(
                    RoundedRectangle(cornerRadius: DesignTokens.Radius.button)
                        .fill(DesignTokens.Colors.neonBlue)
                )
            }
            
            // Bouton billetterie
            if let ticketURL = event.ticketURL {
                Button(action: {
                    UIApplication.shared.open(ticketURL)
                }) {
                    HStack {
                        Image(systemName: "ticket")
                            .font(.system(size: 18))
                        Text("Acheter des billets")
                            .font(DesignTokens.Typography.body)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(DesignTokens.Colors.nightBlack)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, DesignTokens.Spacing.lg)
                    .background(
                        RoundedRectangle(cornerRadius: DesignTokens.Radius.button)
                            .fill(DesignTokens.Colors.neonPink)
                    )
                }
            }
        }
    }
}

// MARK: - Artist Card
struct ArtistCard: View {
    let artist: Artist
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            AsyncImage(url: artist.imageURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(DesignTokens.Colors.gray600.opacity(0.3))
                    .overlay(
                        Image(systemName: "person.circle")
                            .font(.system(size: 20))
                            .foregroundColor(DesignTokens.Colors.gray600)
                    )
            }
            .frame(height: 80)
            .clipped()
            .cornerRadius(DesignTokens.Radius.button)
            
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                Text(artist.name)
                    .font(DesignTokens.Typography.body)
                    .fontWeight(.semibold)
                    .foregroundColor(DesignTokens.Colors.pureWhite)
                    .lineLimit(1)
                
                if let genre = artist.genre {
                    Text(genre)
                        .font(DesignTokens.Typography.caption)
                        .foregroundColor(DesignTokens.Colors.gray600)
                        .lineLimit(1)
                }
            }
        }
        .padding(DesignTokens.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: DesignTokens.Radius.button)
                .fill(DesignTokens.Colors.nightBlack)
                .overlay(
                    RoundedRectangle(cornerRadius: DesignTokens.Radius.button)
                        .stroke(DesignTokens.Colors.gray600.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

// MARK: - Group Selector View
struct GroupSelectorView: View {
    let event: Event
    @Binding var selectedGroup: Group?
    @EnvironmentObject private var sessionStore: SessionStore
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: DesignTokens.Spacing.xl) {
                Text("Ajouter à un groupe")
                    .font(DesignTokens.Typography.heading)
                    .foregroundColor(DesignTokens.Colors.pureWhite)
                    .padding(.top)
                
                LazyVStack(spacing: DesignTokens.Spacing.md) {
                    ForEach(sessionStore.groups) { group in
                        GroupRow(group: group) {
                            addToGroup(group)
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .background(DesignTokens.Colors.nightBlack)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fermer") {
                        dismiss()
                    }
                    .foregroundColor(DesignTokens.Colors.pureWhite)
                }
            }
        }
    }
    
    private func addToGroup(_ group: Group) {
        // Haptic feedback
        let feedback = UIImpactFeedbackGenerator(style: .success)
        feedback.impactOccurred()
        
        selectedGroup = group
        dismiss()
    }
}

// MARK: - Group Row
struct GroupRow: View {
    let group: Group
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: DesignTokens.Spacing.lg) {
                AsyncImage(url: group.imageURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Image(systemName: "person.3.fill")
                        .font(.system(size: 20))
                        .foregroundColor(DesignTokens.Colors.neonBlue)
                }
                .frame(width: 50, height: 50)
                .background(DesignTokens.Colors.gray600.opacity(0.3))
                .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                    Text(group.name)
                        .font(DesignTokens.Typography.body)
                        .fontWeight(.semibold)
                        .foregroundColor(DesignTokens.Colors.pureWhite)
                    
                    Text("\(group.memberCount) membres")
                        .font(DesignTokens.Typography.caption)
                        .foregroundColor(DesignTokens.Colors.gray600)
                }
                
                Spacer()
                
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(DesignTokens.Colors.neonPink)
            }
            .padding(DesignTokens.Spacing.lg)
            .background(
                RoundedRectangle(cornerRadius: DesignTokens.Radius.button)
                    .fill(DesignTokens.Colors.nightBlack)
                    .overlay(
                        RoundedRectangle(cornerRadius: DesignTokens.Radius.button)
                            .stroke(DesignTokens.Colors.gray600.opacity(0.3), lineWidth: 1)
                    )
            )
        }
    }
}

// MARK: - Previews
#Preview {
    EventDetailView(
        event: Event(
            title: "Techno Night à La Bellevilloise",
            description: "Une soirée techno inoubliable avec des DJs internationaux dans le cadre mythique de La Bellevilloise. Venez danser sur les meilleurs sons techno de la capitale.",
            imageURL: URL(string: "https://example.com/event.jpg"),
            date: Date().addingTimeInterval(3600 * 24),
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
    )
    .environmentObject(SessionStore())
} 