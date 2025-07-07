import SwiftUI

// MARK: - Event Card View
// Carte d'événement selon spec : ZStack image + overlay dégradé noir / info (titre, date, distance)

public struct EventCardView: View {
    let event: Event
    let onLike: () -> Void
    let onPass: () -> Void
    let onTap: () -> Void
    
    @State private var dragOffset: CGSize = .zero
    @State private var rotationAngle: Double = 0
    @State private var showLikeBadge: Bool = false
    @State private var showPassBadge: Bool = false
    @State private var cardOpacity: Double = 1.0
    
    public init(
        event: Event,
        onLike: @escaping () -> Void = {},
        onPass: @escaping () -> Void = {},
        onTap: @escaping () -> Void = {}
    ) {
        self.event = event
        self.onLike = onLike
        self.onPass = onPass
        self.onTap = onTap
    }
    
    public var body: some View {
        ZStack {
            // Image de fond
            AsyncImage(url: URL(string: event.imageURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                // Placeholder avec dégradé selon Design System
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
                            .font(.system(size: 50))
                            .foregroundStyle(DesignTokens.Colors.gray600)
                    )
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipped()
            
            // Overlay dégradé noir selon spec
            LinearGradient(
                colors: [
                    Color.clear,
                    Color.clear,
                    Color.black.opacity(0.3),
                    Color.black.opacity(0.8),
                    Color.black.opacity(0.95)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            
            // Contenu informatif en bas
            VStack {
                Spacer()
                
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                    // Tags de genres musicaux
                    HStack {
                        ForEach(Array(event.musicGenres.prefix(2)), id: \.self) { genre in
                            Text("\(genre.emoji) \(genre.rawValue)")
                                .font(DesignTokens.Typography.captionFont)
                                .foregroundStyle(DesignTokens.Colors.pureWhite)
                                .padding(.horizontal, DesignTokens.Spacing.xs)
                                .padding(.vertical, DesignTokens.Spacing.xxs)
                                .background(
                                    DesignTokens.Colors.neonPink.opacity(0.8)
                                        .background(.ultraThinMaterial)
                                )
                                .clipShape(RoundedRectangle(cornerRadius: DesignTokens.Radius.small))
                        }
                        Spacer()
                    }
                    
                    // Titre de l'événement
                    Text(event.title)
                        .font(DesignTokens.Typography.titleFont)
                        .foregroundStyle(DesignTokens.Colors.pureWhite)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    // Infos date et lieu
                    HStack(spacing: DesignTokens.Spacing.sm) {
                        // Date
                        HStack(spacing: DesignTokens.Spacing.xxs) {
                            Image(systemName: "calendar")
                                .font(DesignTokens.Typography.captionFont)
                                .foregroundStyle(DesignTokens.Colors.neonBlue)
                            Text("\(event.formattedDate) • \(event.formattedTime)")
                                .font(DesignTokens.Typography.bodyFont)
                                .foregroundStyle(DesignTokens.Colors.pureWhite)
                        }
                        
                        Spacer()
                        
                        // Distance
                        if !event.formattedDistance.isEmpty {
                            HStack(spacing: DesignTokens.Spacing.xxs) {
                                Image(systemName: "location")
                                    .font(DesignTokens.Typography.captionFont)
                                    .foregroundStyle(DesignTokens.Colors.neonPink)
                                Text(event.formattedDistance)
                                    .font(DesignTokens.Typography.bodyFont)
                                    .foregroundStyle(DesignTokens.Colors.pureWhite)
                            }
                        }
                    }
                    
                    // Lieu et prix
                    HStack {
                        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xxs) {
                            Text(event.venue.name)
                                .font(DesignTokens.Typography.bodyFont)
                                .foregroundStyle(DesignTokens.Colors.gray600)
                            Text(event.venue.city)
                                .font(DesignTokens.Typography.captionFont)
                                .foregroundStyle(DesignTokens.Colors.gray600)
                        }
                        
                        Spacer()
                        
                        // Prix
                        Text(event.priceRange)
                            .font(DesignTokens.Typography.headingFont)
                            .foregroundStyle(DesignTokens.Colors.neonBlue)
                    }
                    
                    // Organisateur si vérifié
                    if event.organizer.verified {
                        HStack(spacing: DesignTokens.Spacing.xxs) {
                            Image(systemName: "checkmark.seal.fill")
                                .font(DesignTokens.Typography.captionFont)
                                .foregroundStyle(DesignTokens.Colors.successColor)
                            Text(event.organizer.name)
                                .font(DesignTokens.Typography.captionFont)
                                .foregroundStyle(DesignTokens.Colors.gray600)
                        }
                    }
                }
                .padding(DesignTokens.Spacing.lg)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            // Badges de Like et Pass selon spec
            if showLikeBadge {
                VStack {
                    HStack {
                        Spacer()
                        LikeBadge()
                            .padding(.top, 60)
                            .padding(.trailing, DesignTokens.Spacing.lg)
                    }
                    Spacer()
                }
                .transition(.asymmetric(
                    insertion: .scale.combined(with: .opacity),
                    removal: .opacity
                ))
            }
            
            if showPassBadge {
                VStack {
                    HStack {
                        PassBadge()
                            .padding(.top, 60)
                            .padding(.leading, DesignTokens.Spacing.lg)
                        Spacer()
                    }
                    Spacer()
                }
                .transition(.asymmetric(
                    insertion: .scale.combined(with: .opacity),
                    removal: .opacity
                ))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(DesignTokens.Colors.backgroundSecondary)
        .clipShape(RoundedRectangle(cornerRadius: DesignTokens.Radius.card))
        .shadow(
            color: DesignTokens.Shadow.card.color,
            radius: DesignTokens.Shadow.card.radius,
            x: DesignTokens.Shadow.card.x,
            y: DesignTokens.Shadow.card.y
        )
        .opacity(cardOpacity)
        .rotationEffect(.degrees(rotationAngle))
        .offset(dragOffset)
        .scaleEffect(dragOffset == .zero ? 1.0 : 0.95)
        .gesture(
            DragGesture()
                .onChanged { value in
                    handleDragChanged(value)
                }
                .onEnded { value in
                    handleDragEnded(value)
                }
        )
        .onTapGesture {
            onTap()
        }
        .animation(DesignTokens.Animation.cardSwipe, value: dragOffset)
        .animation(DesignTokens.Animation.cardSwipe, value: rotationAngle)
        .animation(DesignTokens.Animation.fadeInOut, value: showLikeBadge)
        .animation(DesignTokens.Animation.fadeInOut, value: showPassBadge)
    }
    
    // MARK: - Drag Handlers selon spec
    private func handleDragChanged(_ value: DragGesture.Value) {
        dragOffset = value.translation
        
        // Rotation ±5° selon spec
        let maxRotation = DesignTokens.SwipeThresholds.maxRotation
        rotationAngle = Double(dragOffset.width / 20) * maxRotation
        rotationAngle = max(-maxRotation, min(maxRotation, rotationAngle))
        
        // Badges fade in selon spec (seuil 40pt)
        if dragOffset.width > DesignTokens.SwipeThresholds.previewThreshold {
            if !showLikeBadge {
                showLikeBadge = true
                DesignTokens.Haptics.light.impactOccurred()
            }
            showPassBadge = false
        } else if dragOffset.width < -DesignTokens.SwipeThresholds.previewThreshold {
            if !showPassBadge {
                showPassBadge = true
                DesignTokens.Haptics.light.impactOccurred()
            }
            showLikeBadge = false
        } else {
            showLikeBadge = false
            showPassBadge = false
        }
    }
    
    private func handleDragEnded(_ value: DragGesture.Value) {
        let threshold = DesignTokens.SwipeThresholds.actionThreshold
        
        if value.translation.width > threshold {
            // Like action
            DesignTokens.Haptics.success.notificationOccurred(.success)
            performLikeAction()
        } else if value.translation.width < -threshold {
            // Pass action
            DesignTokens.Haptics.medium.impactOccurred()
            performPassAction()
        } else {
            // Reset position
            resetCardPosition()
        }
    }
    
    private func performLikeAction() {
        withAnimation(DesignTokens.Animation.cardSwipe) {
            dragOffset = CGSize(width: 500, height: 0)
            rotationAngle = DesignTokens.SwipeThresholds.maxRotation
            cardOpacity = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            onLike()
        }
    }
    
    private func performPassAction() {
        withAnimation(DesignTokens.Animation.cardSwipe) {
            dragOffset = CGSize(width: -500, height: 0)
            rotationAngle = -DesignTokens.SwipeThresholds.maxRotation
            cardOpacity = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            onPass()
        }
    }
    
    private func resetCardPosition() {
        withAnimation(DesignTokens.Animation.cardSwipe) {
            dragOffset = .zero
            rotationAngle = 0
            showLikeBadge = false
            showPassBadge = false
            cardOpacity = 1.0
        }
    }
}

// MARK: - Like Badge Component
private struct LikeBadge: View {
    var body: some View {
        Text("LIKE")
            .font(DesignTokens.Typography.headingFont)
            .fontWeight(.black)
            .foregroundStyle(DesignTokens.Colors.pureWhite)
            .padding(.horizontal, DesignTokens.Spacing.lg)
            .padding(.vertical, DesignTokens.Spacing.md)
            .background(
                DesignTokens.Colors.neonPink
                    .shadow(
                        color: DesignTokens.Colors.neonPink.opacity(0.6),
                        radius: 10,
                        x: 0,
                        y: 0
                    )
            )
            .clipShape(RoundedRectangle(cornerRadius: DesignTokens.Radius.button))
            .overlay(
                RoundedRectangle(cornerRadius: DesignTokens.Radius.button)
                    .stroke(DesignTokens.Colors.pureWhite, lineWidth: 2)
            )
            .rotationEffect(.degrees(-15))
    }
}

// MARK: - Pass Badge Component
private struct PassBadge: View {
    var body: some View {
        Text("PASS")
            .font(DesignTokens.Typography.headingFont)
            .fontWeight(.black)
            .foregroundStyle(DesignTokens.Colors.pureWhite)
            .padding(.horizontal, DesignTokens.Spacing.lg)
            .padding(.vertical, DesignTokens.Spacing.md)
            .background(
                DesignTokens.Colors.gray600
                    .shadow(
                        color: DesignTokens.Colors.gray600.opacity(0.6),
                        radius: 10,
                        x: 0,
                        y: 0
                    )
            )
            .clipShape(RoundedRectangle(cornerRadius: DesignTokens.Radius.button))
            .overlay(
                RoundedRectangle(cornerRadius: DesignTokens.Radius.button)
                    .stroke(DesignTokens.Colors.pureWhite, lineWidth: 2)
            )
            .rotationEffect(.degrees(15))
    }
}

// MARK: - Preview
#Preview("Event Card") {
    VStack {
        EventCardView(
            event: Event.mockEvents[0],
            onLike: { print("Liked!") },
            onPass: { print("Passed!") },
            onTap: { print("Tapped!") }
        )
        .frame(width: 350, height: 500)
        
        Spacer()
    }
    .padding()
    .background(DesignTokens.Colors.nightBlack)
    .preferredColorScheme(.dark)
}

#Preview("Event Card Stack") {
    ZStack {
        ForEach(Array(Event.mockEvents.enumerated()), id: \.offset) { index, event in
            EventCardView(
                event: event,
                onLike: { print("Liked \(event.title)") },
                onPass: { print("Passed \(event.title)") }
            )
            .frame(width: 350, height: 500)
            .scaleEffect(
                index == 0 ? 1.0 :
                index == 1 ? 0.97 :
                0.94
            )
            .offset(y: CGFloat(index * 4))
            .zIndex(Double(Event.mockEvents.count - index))
        }
    }
    .padding()
    .background(DesignTokens.Colors.nightBlack)
    .preferredColorScheme(.dark)
} 