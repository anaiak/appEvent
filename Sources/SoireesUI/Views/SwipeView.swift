import SwiftUI

// MARK: - Swipe View
// Vue principale du flux de swipe avec deck de cartes selon spec

public struct SwipeView: View {
    @StateObject private var viewModel = SwipeViewModel()
    @State private var showingEventDetail = false
    @State private var selectedEvent: Event?
    @State private var showingProfile = false
    @State private var showingGroups = false
    
    public init() {}
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background global
                DesignTokens.Colors.nightBlack
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header avec navigation
                    headerView
                        .padding(.horizontal, DesignTokens.Spacing.lg)
                        .padding(.top, DesignTokens.Spacing.md)
                    
                    // Zone principale de swipe
                    ZStack {
                        if viewModel.hasCurrentEvent {
                            // Deck de cartes selon spec
                            cardDeckView(in: geometry)
                        } else if viewModel.isLoading {
                            loadingView
                        } else {
                            emptyStateView
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.horizontal, DesignTokens.Spacing.lg)
                    
                    // Footer avec actions
                    if viewModel.hasCurrentEvent {
                        footerActionsView
                            .padding(.horizontal, DesignTokens.Spacing.xl)
                            .padding(.bottom, DesignTokens.Spacing.lg)
                    }
                }
                
                // Error message overlay
                if let errorMessage = viewModel.errorMessage {
                    errorOverlay(errorMessage)
                }
            }
        }
        .navigationBarHidden(true)
        .refreshable {
            await viewModel.refresh()
        }
        .task {
            if viewModel.events.isEmpty {
                await viewModel.loadEvents()
            }
        }
        .sheet(isPresented: $showingEventDetail) {
            if let event = selectedEvent {
                EventDetailView(event: event)
            }
        }
        .sheet(isPresented: $showingProfile) {
            ProfileView()
        }
        .sheet(isPresented: $showingGroups) {
            GroupsView()
        }
    }
    
    // MARK: - Header View
    private var headerView: some View {
        HStack {
            // Logo/Title
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.xxs) {
                Text("SoireesSwipe")
                    .font(DesignTokens.Typography.titleFont)
                    .foregroundStyle(DesignTokens.Colors.pureWhite)
                
                if !viewModel.isLoading && viewModel.hasCurrentEvent {
                    Text("\(viewModel.events.count - viewModel.currentEventIndex) soirées disponibles")
                        .font(DesignTokens.Typography.captionFont)
                        .foregroundStyle(DesignTokens.Colors.gray600)
                }
            }
            
            Spacer()
            
            // Navigation buttons
            HStack(spacing: DesignTokens.Spacing.md) {
                // Groupes button
                Button(action: {
                    showingGroups = true
                    DesignTokens.Haptics.selection.selectionChanged()
                }) {
                    Image(systemName: "person.3.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(DesignTokens.Colors.neonBlue)
                        .frame(width: 40, height: 40)
                        .background(
                            Circle()
                                .fill(DesignTokens.Colors.backgroundSecondary)
                                .overlay(
                                    Circle()
                                        .stroke(DesignTokens.Colors.neonBlue.opacity(0.3), lineWidth: 1)
                                )
                        )
                }
                
                // Profile button
                Button(action: {
                    showingProfile = true
                    DesignTokens.Haptics.selection.selectionChanged()
                }) {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(DesignTokens.Colors.neonPink)
                        .frame(width: 40, height: 40)
                        .background(
                            Circle()
                                .fill(DesignTokens.Colors.backgroundSecondary)
                                .overlay(
                                    Circle()
                                        .stroke(DesignTokens.Colors.neonPink.opacity(0.3), lineWidth: 1)
                                )
                        )
                }
            }
        }
    }
    
    // MARK: - Card Deck View (selon spec)
    private func cardDeckView(in geometry: GeometryProxy) -> some View {
        let cardWidth = geometry.size.width - (DesignTokens.Spacing.lg * 2)
        let cardHeight = geometry.size.height * 0.75
        
        return ZStack {
            // 3 cartes pré-chargées selon spec avec scale 0.94 / 0.97 / 1.0
            ForEach(Array(viewModel.eventsInDeck.enumerated()), id: \.offset) { index, event in
                EventCardView(
                    event: event,
                    onLike: {
                        Task {
                            await viewModel.likeEvent()
                        }
                    },
                    onPass: {
                        Task {
                            await viewModel.passEvent()
                        }
                    },
                    onTap: {
                        selectedEvent = event
                        showingEventDetail = true
                    }
                )
                .frame(width: cardWidth, height: cardHeight)
                .scaleEffect(scaleForCardIndex(index))
                .offset(y: offsetForCardIndex(index))
                .zIndex(Double(viewModel.eventsInDeck.count - index))
                .opacity(opacityForCardIndex(index))
                .animation(DesignTokens.Animation.cardSwipe, value: viewModel.currentEventIndex)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
    }
    
    // MARK: - Card Stack Calculations (selon spec)
    private func scaleForCardIndex(_ index: Int) -> CGFloat {
        switch index {
        case 0: return DesignTokens.SwipeThresholds.cardScale.top        // 1.0
        case 1: return DesignTokens.SwipeThresholds.cardScale.middle     // 0.97
        case 2: return DesignTokens.SwipeThresholds.cardScale.background // 0.94
        default: return 0.9
        }
    }
    
    private func offsetForCardIndex(_ index: Int) -> CGFloat {
        switch index {
        case 0: return 0
        case 1: return DesignTokens.Spacing.xs
        case 2: return DesignTokens.Spacing.md
        default: return DesignTokens.Spacing.lg
        }
    }
    
    private func opacityForCardIndex(_ index: Int) -> Double {
        switch index {
        case 0: return 1.0
        case 1: return 0.8
        case 2: return 0.6
        default: return 0.4
        }
    }
    
    // MARK: - Footer Actions
    private var footerActionsView: some View {
        HStack(spacing: DesignTokens.Spacing.xl) {
            // Pass button
            Button(action: {
                Task {
                    await viewModel.passEvent()
                }
            }) {
                Image(systemName: "xmark")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(DesignTokens.Colors.pureWhite)
                    .frame(width: 60, height: 60)
                    .background(
                        Circle()
                            .fill(DesignTokens.Colors.gray600)
                            .shadow(
                                color: DesignTokens.Colors.gray600.opacity(0.3),
                                radius: 8,
                                x: 0,
                                y: 4
                            )
                    )
            }
            .buttonStyle(PlainButtonStyle())
            
            // Super Like button (bonus)
            Button(action: {
                // TODO: Implémenter super like
                DesignTokens.Haptics.heavy.impactOccurred()
            }) {
                Image(systemName: "star.fill")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(DesignTokens.Colors.pureWhite)
                    .frame(width: 50, height: 50)
                    .background(
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        DesignTokens.Colors.neonBlue,
                                        DesignTokens.Colors.neonPink
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .shadow(
                                color: DesignTokens.Colors.neonBlue.opacity(0.4),
                                radius: 8,
                                x: 0,
                                y: 4
                            )
                    )
            }
            .buttonStyle(PlainButtonStyle())
            
            // Like button
            Button(action: {
                Task {
                    await viewModel.likeEvent()
                }
            }) {
                Image(systemName: "heart.fill")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(DesignTokens.Colors.pureWhite)
                    .frame(width: 60, height: 60)
                    .background(
                        Circle()
                            .fill(DesignTokens.Colors.neonPink)
                            .shadow(
                                color: DesignTokens.Colors.neonPink.opacity(0.4),
                                radius: 8,
                                x: 0,
                                y: 4
                            )
                    )
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.vertical, DesignTokens.Spacing.md)
    }
    
    // MARK: - Loading View
    private var loadingView: some View {
        VStack(spacing: DesignTokens.Spacing.lg) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(DesignTokens.Colors.neonPink)
            
            Text("Chargement des soirées...")
                .font(DesignTokens.Typography.bodyFont)
                .foregroundStyle(DesignTokens.Colors.gray600)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Empty State
    private var emptyStateView: some View {
        VStack(spacing: DesignTokens.Spacing.lg) {
            Image(systemName: "party.popper")
                .font(.system(size: 80))
                .foregroundStyle(DesignTokens.Colors.gray600)
            
            VStack(spacing: DesignTokens.Spacing.sm) {
                Text("Plus de soirées disponibles")
                    .font(DesignTokens.Typography.headingFont)
                    .foregroundStyle(DesignTokens.Colors.pureWhite)
                
                Text("Revenez plus tard pour découvrir de nouveaux événements !")
                    .font(DesignTokens.Typography.bodyFont)
                    .foregroundStyle(DesignTokens.Colors.gray600)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: {
                Task {
                    await viewModel.refresh()
                }
            }) {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("Actualiser")
                }
                .font(DesignTokens.Typography.bodyFont)
                .foregroundStyle(DesignTokens.Colors.pureWhite)
                .padding(.horizontal, DesignTokens.Spacing.lg)
                .padding(.vertical, DesignTokens.Spacing.md)
                .background(DesignTokens.Colors.neonPink)
                .clipShape(RoundedRectangle(cornerRadius: DesignTokens.Radius.button))
            }
        }
        .padding(DesignTokens.Spacing.xl)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Error Overlay
    private func errorOverlay(_ message: String) -> some View {
        VStack {
            Spacer()
            
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundStyle(DesignTokens.Colors.warningColor)
                Text(message)
                    .font(DesignTokens.Typography.bodyFont)
                    .foregroundStyle(DesignTokens.Colors.pureWhite)
            }
            .padding(DesignTokens.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: DesignTokens.Radius.button)
                    .fill(DesignTokens.Colors.backgroundSecondary)
                    .overlay(
                        RoundedRectangle(cornerRadius: DesignTokens.Radius.button)
                            .stroke(DesignTokens.Colors.warningColor, lineWidth: 1)
                    )
            )
            .padding(.horizontal, DesignTokens.Spacing.lg)
            .padding(.bottom, DesignTokens.Spacing.xl)
        }
        .transition(.move(edge: .bottom).combined(with: .opacity))
        .animation(DesignTokens.Animation.standardSpring, value: viewModel.errorMessage)
    }
}

// MARK: - Placeholder Views (à développer plus tard)
private struct EventDetailView: View {
    let event: Event
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.lg) {
                    AsyncImage(url: URL(string: event.imageURL)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Rectangle()
                            .fill(DesignTokens.Colors.backgroundSecondary)
                    }
                    .frame(height: 300)
                    .clipped()
                    
                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
                        Text(event.title)
                            .font(DesignTokens.Typography.titleFont)
                            .foregroundStyle(DesignTokens.Colors.pureWhite)
                        
                        Text(event.description)
                            .font(DesignTokens.Typography.bodyFont)
                            .foregroundStyle(DesignTokens.Colors.gray600)
                        
                        // Plus de détails à implémenter...
                    }
                    .padding(DesignTokens.Spacing.lg)
                }
            }
            .background(DesignTokens.Colors.nightBlack)
            .navigationTitle("Détail de l'événement")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

private struct ProfileView: View {
    var body: some View {
        NavigationView {
            Text("Profil utilisateur")
                .font(DesignTokens.Typography.titleFont)
                .foregroundStyle(DesignTokens.Colors.pureWhite)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(DesignTokens.Colors.nightBlack)
                .navigationTitle("Profil")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

private struct GroupsView: View {
    var body: some View {
        NavigationView {
            Text("Groupes d'amis")
                .font(DesignTokens.Typography.titleFont)
                .foregroundStyle(DesignTokens.Colors.pureWhite)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(DesignTokens.Colors.nightBlack)
                .navigationTitle("Groupes")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Preview
#Preview("Swipe View") {
    SwipeView()
        .preferredColorScheme(.dark)
}

#Preview("Swipe View - Loading") {
    SwipeView()
        .preferredColorScheme(.dark)
        .onAppear {
            // Mock loading state
        }
} 