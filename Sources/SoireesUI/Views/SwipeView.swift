import SwiftUI

// MARK: - Swipe View
public struct SwipeView: View {
    @StateObject private var viewModel = SwipeViewModel()
    @EnvironmentObject private var sessionStore: SessionStore
    @State private var showingProfile = false
    @State private var showingGroups = false
    @State private var selectedEvent: Event?
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            ZStack {
                // Background
                DesignTokens.Colors.nightBlack
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    headerView
                        .padding(.horizontal, DesignTokens.Spacing.xl)
                        .padding(.top, DesignTokens.Spacing.md)
                    
                    // Card Stack
                    cardStackView
                        .padding(.horizontal, DesignTokens.Spacing.xl)
                    
                    // Action Buttons
                    actionButtonsView
                        .padding(.horizontal, DesignTokens.Spacing.xl)
                        .padding(.bottom, DesignTokens.Spacing.xl)
                }
                
                // Loading Overlay
                if viewModel.isLoading {
                    loadingOverlay
                }
            }
            .navigationBarHidden(true)
            .refreshable {
                await viewModel.loadEvents()
            }
            .task {
                await viewModel.loadEvents()
            }
            .sheet(isPresented: $showingProfile) {
                ProfileView()
                    .environmentObject(sessionStore)
            }
            .sheet(isPresented: $showingGroups) {
                GroupsView()
                    .environmentObject(sessionStore)
            }
            .sheet(item: $selectedEvent) { event in
                EventDetailView(event: event)
                    .environmentObject(sessionStore)
            }
        }
    }
    
    // MARK: - Header View
    private var headerView: some View {
        HStack {
            // Logo/Title
            Text("Soirées")
                .font(DesignTokens.Typography.title)
                .foregroundColor(DesignTokens.Colors.pureWhite)
            
            Spacer()
            
            // Action Buttons
            HStack(spacing: DesignTokens.Spacing.lg) {
                // Groups Button
                Button(action: { showingGroups = true }) {
                    Image(systemName: "person.3.fill")
                        .font(.system(size: 20))
                        .foregroundColor(DesignTokens.Colors.neonBlue)
                        .frame(width: 44, height: 44)
                        .background(
                            Circle()
                                .fill(DesignTokens.Colors.neonBlue.opacity(0.1))
                                .overlay(
                                    Circle()
                                        .stroke(DesignTokens.Colors.neonBlue.opacity(0.3), lineWidth: 1)
                                )
                        )
                }
                
                // Profile Button
                Button(action: { showingProfile = true }) {
                    AsyncImage(url: sessionStore.currentUser?.avatarURL) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Image(systemName: "person.fill")
                            .font(.system(size: 20))
                            .foregroundColor(DesignTokens.Colors.pureWhite)
                    }
                    .frame(width: 44, height: 44)
                    .background(DesignTokens.Colors.gray600)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(DesignTokens.Colors.neonPink.opacity(0.3), lineWidth: 2)
                    )
                }
            }
        }
    }
    
    // MARK: - Card Stack View
    private var cardStackView: some View {
        GeometryReader { geometry in
            ZStack {
                // Troisième carte (arrière-plan)
                if let thirdEvent = viewModel.thirdEvent {
                    EventCardView(
                        event: thirdEvent,
                        scale: DesignTokens.Animation.CardScale.background
                    )
                    .frame(
                        width: geometry.size.width,
                        height: geometry.size.height * 0.85
                    )
                    .zIndex(1)
                }
                
                // Deuxième carte (milieu)
                if let nextEvent = viewModel.nextEvent {
                    EventCardView(
                        event: nextEvent,
                        scale: DesignTokens.Animation.CardScale.middle
                    )
                    .frame(
                        width: geometry.size.width,
                        height: geometry.size.height * 0.9
                    )
                    .zIndex(2)
                }
                
                // Première carte (avant-plan)
                if let currentEvent = viewModel.currentEvent {
                    EventCardView(
                        event: currentEvent,
                        dragOffset: viewModel.dragOffset,
                        rotation: viewModel.rotation,
                        likeOpacity: viewModel.likeOpacity,
                        passOpacity: viewModel.passOpacity,
                        scale: DesignTokens.Animation.CardScale.front
                    )
                    .frame(
                        width: geometry.size.width,
                        height: geometry.size.height * 0.95
                    )
                    .zIndex(3)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                viewModel.updateDragOffset(value.translation)
                            }
                            .onEnded { value in
                                handleDragEnd(value.translation)
                            }
                    )
                    .onTapGesture {
                        selectedEvent = currentEvent
                    }
                }
                
                // État vide
                if !viewModel.hasMoreEvents && !viewModel.isLoading {
                    emptyStateView
                        .zIndex(0)
                }
            }
        }
        .frame(height: UIScreen.main.bounds.height * 0.65)
    }
    
    // MARK: - Action Buttons View
    private var actionButtonsView: some View {
        HStack(spacing: DesignTokens.Spacing.xxl) {
            // Pass Button
            Button(action: { 
                viewModel.handleSwipe(direction: .pass)
            }) {
                Image(systemName: "xmark")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(DesignTokens.Colors.gray600)
                    .frame(width: 60, height: 60)
                    .background(
                        Circle()
                            .fill(DesignTokens.Colors.pureWhite)
                            .shadow(
                                color: DesignTokens.Colors.nightBlack.opacity(0.1),
                                radius: 8,
                                x: 0,
                                y: 4
                            )
                    )
            }
            .disabled(!viewModel.hasMoreEvents)
            
            Spacer()
            
            // Like Button
            Button(action: { 
                viewModel.handleSwipe(direction: .like)
            }) {
                Image(systemName: "heart.fill")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(DesignTokens.Colors.pureWhite)
                    .frame(width: 70, height: 70)
                    .background(
                        Circle()
                            .fill(DesignTokens.Colors.neonPink)
                            .shadow(
                                color: DesignTokens.Colors.neonPink.opacity(0.3),
                                radius: 12,
                                x: 0,
                                y: 6
                            )
                    )
            }
            .disabled(!viewModel.hasMoreEvents)
        }
    }
    
    // MARK: - Empty State View
    private var emptyStateView: some View {
        VStack(spacing: DesignTokens.Spacing.xl) {
            Image(systemName: "sparkles")
                .font(.system(size: 60))
                .foregroundColor(DesignTokens.Colors.neonPink)
            
            VStack(spacing: DesignTokens.Spacing.md) {
                Text("Plus d'événements pour le moment")
                    .font(DesignTokens.Typography.heading)
                    .foregroundColor(DesignTokens.Colors.pureWhite)
                    .multilineTextAlignment(.center)
                
                Text("Reviens plus tard pour découvrir de nouvelles soirées !")
                    .font(DesignTokens.Typography.body)
                    .foregroundColor(DesignTokens.Colors.gray600)
                    .multilineTextAlignment(.center)
            }
            
            Button("Actualiser") {
                Task {
                    await viewModel.loadEvents()
                }
            }
            .font(DesignTokens.Typography.body)
            .foregroundColor(DesignTokens.Colors.pureWhite)
            .padding(.horizontal, DesignTokens.Spacing.xl)
            .padding(.vertical, DesignTokens.Spacing.lg)
            .background(
                RoundedRectangle(cornerRadius: DesignTokens.Radius.button)
                    .fill(DesignTokens.Colors.neonPink)
            )
        }
        .padding(DesignTokens.Spacing.xxl)
    }
    
    // MARK: - Loading Overlay
    private var loadingOverlay: some View {
        ZStack {
            DesignTokens.Colors.nightBlack.opacity(0.8)
                .ignoresSafeArea()
            
            VStack(spacing: DesignTokens.Spacing.lg) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: DesignTokens.Colors.neonPink))
                    .scaleEffect(1.5)
                
                Text("Chargement des événements...")
                    .font(DesignTokens.Typography.body)
                    .foregroundColor(DesignTokens.Colors.pureWhite)
            }
        }
    }
    
    // MARK: - Private Methods
    private func handleDragEnd(_ translation: CGSize) {
        if let direction = viewModel.shouldTriggerSwipe(for: translation) {
            viewModel.handleSwipe(direction: direction)
        } else {
            viewModel.resetCardPosition()
        }
    }
}

// MARK: - Previews
#Preview {
    SwipeView()
        .environmentObject(SessionStore())
} 