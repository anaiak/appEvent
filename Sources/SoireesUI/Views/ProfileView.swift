import SwiftUI

// MARK: - Profile View
// Vue de profil utilisateur avec paramètres et préférences

public struct ProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showingSettings = false
    @State private var showingPreferences = false
    @State private var showingAbout = false
    
    // Mock user data
    @State private var userName = "Alex Martin"
    @State private var userEmail = "alex.martin@example.com"
    @State private var eventsLiked = 142
    @State private var eventsAttended = 28
    @State private var friendsCount = 89
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: DesignTokens.Spacing.lg) {
                    // Header Profile
                    profileHeaderView
                    
                    // Stats Section
                    statsSection
                    
                    // Menu Options
                    menuSection
                    
                    // About Section
                    aboutSection
                }
                .padding(DesignTokens.Spacing.lg)
            }
            .background(DesignTokens.Colors.nightBlack)
            .navigationTitle("Profil")
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
    
    // MARK: - Profile Header
    private var profileHeaderView: some View {
        VStack(spacing: DesignTokens.Spacing.lg) {
            // Avatar
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                DesignTokens.Colors.neonPink,
                                DesignTokens.Colors.neonBlue
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)
                
                Image(systemName: "person.fill")
                    .font(.system(size: 50))
                    .foregroundStyle(DesignTokens.Colors.pureWhite)
            }
            
            // User Info
            VStack(spacing: DesignTokens.Spacing.sm) {
                Text(userName)
                    .font(DesignTokens.Typography.titleFont)
                    .foregroundStyle(DesignTokens.Colors.pureWhite)
                
                Text(userEmail)
                    .font(DesignTokens.Typography.bodyFont)
                    .foregroundStyle(DesignTokens.Colors.gray600)
                
                // Status badge
                HStack(spacing: DesignTokens.Spacing.xs) {
                    Circle()
                        .fill(DesignTokens.Colors.successColor)
                        .frame(width: 8, height: 8)
                    Text("Actif")
                        .font(DesignTokens.Typography.captionFont)
                        .foregroundStyle(DesignTokens.Colors.successColor)
                }
            }
        }
        .padding(.vertical, DesignTokens.Spacing.lg)
    }
    
    // MARK: - Stats Section
    private var statsSection: some View {
        HStack(spacing: DesignTokens.Spacing.lg) {
            StatCard(
                title: "Likés",
                value: "\(eventsLiked)",
                icon: "heart.fill",
                color: DesignTokens.Colors.neonPink
            )
            
            StatCard(
                title: "Participés",
                value: "\(eventsAttended)",
                icon: "ticket.fill",
                color: DesignTokens.Colors.neonBlue
            )
            
            StatCard(
                title: "Amis",
                value: "\(friendsCount)",
                icon: "person.3.fill",
                color: DesignTokens.Colors.successColor
            )
        }
    }
    
    // MARK: - Menu Section
    private var menuSection: some View {
        VStack(spacing: DesignTokens.Spacing.sm) {
            MenuRow(
                icon: "gearshape.fill",
                title: "Paramètres",
                subtitle: "Notifications, compte, confidentialité",
                iconColor: DesignTokens.Colors.gray600,
                action: {
                    showingSettings = true
                }
            )
            
            MenuRow(
                icon: "heart.circle.fill",
                title: "Mes préférences",
                subtitle: "Genres musicaux, types d'événements",
                iconColor: DesignTokens.Colors.neonPink,
                action: {
                    showingPreferences = true
                }
            )
            
            MenuRow(
                icon: "calendar.circle.fill",
                title: "Mes événements",
                subtitle: "Historique et événements à venir",
                iconColor: DesignTokens.Colors.neonBlue,
                action: {
                    // TODO: Navigate to events
                }
            )
            
            MenuRow(
                icon: "person.2.circle.fill",
                title: "Mes groupes",
                subtitle: "Gérer vos groupes d'amis",
                iconColor: DesignTokens.Colors.successColor,
                action: {
                    // TODO: Navigate to groups
                }
            )
            
            MenuRow(
                icon: "questionmark.circle.fill",
                title: "Aide & Support",
                subtitle: "FAQ, contact, signaler un problème",
                iconColor: DesignTokens.Colors.warningColor,
                action: {
                    showingAbout = true
                }
            )
        }
    }
    
    // MARK: - About Section
    private var aboutSection: some View {
        VStack(spacing: DesignTokens.Spacing.md) {
            Text("SoireesSwipe v1.0")
                .font(DesignTokens.Typography.captionFont)
                .foregroundStyle(DesignTokens.Colors.gray600)
            
            Text("Découvrez les meilleures soirées près de chez vous")
                .font(DesignTokens.Typography.captionFont)
                .foregroundStyle(DesignTokens.Colors.gray600)
                .multilineTextAlignment(.center)
        }
        .padding(.top, DesignTokens.Spacing.xl)
    }
}

// MARK: - Supporting Views

private struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: DesignTokens.Spacing.sm) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundStyle(color)
            
            Text(value)
                .font(DesignTokens.Typography.titleFont)
                .foregroundStyle(DesignTokens.Colors.pureWhite)
            
            Text(title)
                .font(DesignTokens.Typography.captionFont)
                .foregroundStyle(DesignTokens.Colors.gray600)
        }
        .frame(maxWidth: .infinity)
        .padding(DesignTokens.Spacing.md)
        .background(DesignTokens.Colors.backgroundSecondary)
        .clipShape(RoundedRectangle(cornerRadius: DesignTokens.Radius.button))
    }
}

private struct MenuRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let iconColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: DesignTokens.Spacing.md) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundStyle(iconColor)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(iconColor.opacity(0.2))
                    )
                
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.xxs) {
                    Text(title)
                        .font(DesignTokens.Typography.bodyFont)
                        .foregroundStyle(DesignTokens.Colors.pureWhite)
                    
                    Text(subtitle)
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

// MARK: - Preview
#Preview("Profile View") {
    ProfileView()
        .preferredColorScheme(.dark)
} 