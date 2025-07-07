import SwiftUI

// MARK: - Profile View
public struct ProfileView: View {
    @EnvironmentObject private var sessionStore: SessionStore
    @Environment(\.dismiss) private var dismiss
    @State private var showingSettings = false
    @State private var showingDeleteConfirmation = false
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            List {
                // Header Section
                profileHeaderSection
                
                // Préférences
                preferencesSection
                
                // Actions
                actionsSection
            }
            .listStyle(.insetGrouped)
            .background(DesignTokens.Colors.nightBlack)
            .scrollContentBackground(.hidden)
            .navigationTitle("Profil")
            .navigationBarTitleDisplayMode(.large)
            .foregroundColor(DesignTokens.Colors.pureWhite)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fermer") {
                        dismiss()
                    }
                    .foregroundColor(DesignTokens.Colors.pureWhite)
                }
            }
            .sheet(isPresented: $showingSettings) {
                AppSettingsView()
            }
            .confirmationDialog(
                "Supprimer le compte",
                isPresented: $showingDeleteConfirmation,
                titleVisibility: .visible
            ) {
                Button("Supprimer", role: .destructive) {
                    deleteAccount()
                }
                Button("Annuler", role: .cancel) { }
            } message: {
                Text("Cette action est irréversible. Toutes vos données seront supprimées.")
            }
        }
    }
    
    // MARK: - Profile Header Section
    private var profileHeaderSection: some View {
        Section {
            HStack(spacing: DesignTokens.Spacing.lg) {
                // Avatar
                AsyncImage(url: sessionStore.currentUser?.avatarURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Image(systemName: "person.fill")
                        .font(.system(size: 40))
                        .foregroundColor(DesignTokens.Colors.pureWhite)
                }
                .frame(width: 80, height: 80)
                .background(DesignTokens.Colors.gray600)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(DesignTokens.Colors.neonPink, lineWidth: 3)
                )
                
                // Informations utilisateur
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                    Text(sessionStore.currentUser?.name ?? "Utilisateur")
                        .font(DesignTokens.Typography.heading)
                        .foregroundColor(DesignTokens.Colors.pureWhite)
                    
                    if let email = sessionStore.currentUser?.email {
                        Text(email)
                            .font(DesignTokens.Typography.body)
                            .foregroundColor(DesignTokens.Colors.gray600)
                    }
                    
                    Text("\(sessionStore.groups.count) groupes")
                        .font(DesignTokens.Typography.caption)
                        .foregroundColor(DesignTokens.Colors.neonBlue)
                }
                
                Spacer()
            }
            .padding(.vertical, DesignTokens.Spacing.md)
            .listRowBackground(DesignTokens.Colors.nightBlack)
        }
    }
    
    // MARK: - Preferences Section
    private var preferencesSection: some View {
        Section("Préférences") {
            // Genres musicaux
            NavigationLink(destination: MusicGenresView()) {
                PreferenceRow(
                    icon: "music.note",
                    title: "Genres musicaux",
                    value: "\(sessionStore.currentUser?.preferences.musicGenres.count ?? 0) sélectionnés",
                    color: DesignTokens.Colors.neonPink
                )
            }
            
            // Rayon de recherche
            NavigationLink(destination: RadiusSettingsView()) {
                PreferenceRow(
                    icon: "location.circle",
                    title: "Rayon de recherche",
                    value: "\(Int(sessionStore.currentUser?.preferences.maxDistance ?? 25)) km",
                    color: DesignTokens.Colors.neonBlue
                )
            }
            
            // Budget maximum
            NavigationLink(destination: BudgetSettingsView()) {
                PreferenceRow(
                    icon: "eurosign.circle",
                    title: "Budget maximum",
                    value: "\(Int(sessionStore.currentUser?.preferences.maxBudget ?? 50)) €",
                    color: DesignTokens.Colors.neonPink
                )
            }
            
            // Notifications
            PreferenceRow(
                icon: "bell",
                title: "Notifications",
                value: sessionStore.currentUser?.preferences.notificationsEnabled == true ? "Activées" : "Désactivées",
                color: DesignTokens.Colors.neonBlue
            )
        }
        .foregroundColor(DesignTokens.Colors.pureWhite)
        .listRowBackground(DesignTokens.Colors.nightBlack)
    }
    
    // MARK: - Actions Section
    private var actionsSection: some View {
        Section {
            // Paramètres
            Button(action: { showingSettings = true }) {
                PreferenceRow(
                    icon: "gearshape",
                    title: "Paramètres",
                    value: "",
                    color: DesignTokens.Colors.gray600
                )
            }
            
            // Déconnexion
            Button(action: { sessionStore.signOut() }) {
                PreferenceRow(
                    icon: "rectangle.portrait.and.arrow.right",
                    title: "Se déconnecter",
                    value: "",
                    color: DesignTokens.Colors.gray600
                )
            }
            
            // Supprimer le compte
            Button(action: { showingDeleteConfirmation = true }) {
                PreferenceRow(
                    icon: "trash",
                    title: "Supprimer le compte",
                    value: "",
                    color: .red
                )
            }
        }
        .foregroundColor(DesignTokens.Colors.pureWhite)
        .listRowBackground(DesignTokens.Colors.nightBlack)
    }
    
    // MARK: - Private Methods
    private func deleteAccount() {
        // Implémentation de la suppression du compte
        sessionStore.signOut()
        dismiss()
    }
}

// MARK: - Preference Row
struct PreferenceRow: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: DesignTokens.Spacing.lg) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                Text(title)
                    .font(DesignTokens.Typography.body)
                    .foregroundColor(DesignTokens.Colors.pureWhite)
                
                if !value.isEmpty {
                    Text(value)
                        .font(DesignTokens.Typography.caption)
                        .foregroundColor(DesignTokens.Colors.gray600)
                }
            }
            
            Spacer()
            
            if !value.isEmpty {
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(DesignTokens.Colors.gray600)
            }
        }
        .padding(.vertical, DesignTokens.Spacing.sm)
    }
}

// MARK: - Music Genres View
struct MusicGenresView: View {
    @EnvironmentObject private var sessionStore: SessionStore
    @State private var selectedGenres: Set<String> = []
    
    private let availableGenres = [
        "Techno", "House", "Hip-Hop", "Rap", "Electronic", "Pop", "Rock",
        "Jazz", "Blues", "Reggae", "Funk", "Soul", "R&B", "Alternative",
        "Indie", "Punk", "Metal", "Classical", "World", "Ambient"
    ]
    
    var body: some View {
        List {
            ForEach(availableGenres, id: \.self) { genre in
                GenreToggleRow(
                    genre: genre,
                    isSelected: selectedGenres.contains(genre)
                ) { isSelected in
                    if isSelected {
                        selectedGenres.insert(genre)
                    } else {
                        selectedGenres.remove(genre)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .background(DesignTokens.Colors.nightBlack)
        .scrollContentBackground(.hidden)
        .navigationTitle("Genres musicaux")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            selectedGenres = Set(sessionStore.currentUser?.preferences.musicGenres ?? [])
        }
        .onDisappear {
            // Sauvegarder les préférences
            // sessionStore.updateMusicGenres(Array(selectedGenres))
        }
    }
}

// MARK: - Genre Toggle Row
struct GenreToggleRow: View {
    let genre: String
    let isSelected: Bool
    let onToggle: (Bool) -> Void
    
    var body: some View {
        HStack {
            Text(genre)
                .font(DesignTokens.Typography.body)
                .foregroundColor(DesignTokens.Colors.pureWhite)
            
            Spacer()
            
            Toggle("", isOn: .init(
                get: { isSelected },
                set: { onToggle($0) }
            ))
            .toggleStyle(SwitchToggleStyle(tint: DesignTokens.Colors.neonPink))
        }
        .padding(.vertical, DesignTokens.Spacing.sm)
        .listRowBackground(DesignTokens.Colors.nightBlack)
    }
}

// MARK: - Radius Settings View
struct RadiusSettingsView: View {
    @EnvironmentObject private var sessionStore: SessionStore
    @State private var radius: Double = 25.0
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xl) {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
                Text("Rayon de recherche")
                    .font(DesignTokens.Typography.heading)
                    .foregroundColor(DesignTokens.Colors.pureWhite)
                
                Text("Définit la distance maximale pour la recherche d'événements autour de votre position.")
                    .font(DesignTokens.Typography.body)
                    .foregroundColor(DesignTokens.Colors.gray600)
            }
            
            VStack(spacing: DesignTokens.Spacing.lg) {
                HStack {
                    Text("Distance")
                        .font(DesignTokens.Typography.body)
                        .foregroundColor(DesignTokens.Colors.pureWhite)
                    
                    Spacer()
                    
                    Text("\(Int(radius)) km")
                        .font(DesignTokens.Typography.body)
                        .fontWeight(.semibold)
                        .foregroundColor(DesignTokens.Colors.neonBlue)
                }
                
                Slider(value: $radius, in: 5...100, step: 5)
                    .accentColor(DesignTokens.Colors.neonBlue)
            }
            
            Spacer()
        }
        .padding(DesignTokens.Spacing.xl)
        .background(DesignTokens.Colors.nightBlack)
        .navigationTitle("Rayon")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            radius = sessionStore.currentUser?.preferences.maxDistance ?? 25.0
        }
        .onDisappear {
            // Sauvegarder les préférences
            // sessionStore.updateMaxDistance(radius)
        }
    }
}

// MARK: - Budget Settings View
struct BudgetSettingsView: View {
    @EnvironmentObject private var sessionStore: SessionStore
    @State private var budget: Double = 50.0
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xl) {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
                Text("Budget maximum")
                    .font(DesignTokens.Typography.heading)
                    .foregroundColor(DesignTokens.Colors.pureWhite)
                
                Text("Définit le prix maximum que vous êtes prêt à payer pour un événement.")
                    .font(DesignTokens.Typography.body)
                    .foregroundColor(DesignTokens.Colors.gray600)
            }
            
            VStack(spacing: DesignTokens.Spacing.lg) {
                HStack {
                    Text("Budget")
                        .font(DesignTokens.Typography.body)
                        .foregroundColor(DesignTokens.Colors.pureWhite)
                    
                    Spacer()
                    
                    Text("\(Int(budget)) €")
                        .font(DesignTokens.Typography.body)
                        .fontWeight(.semibold)
                        .foregroundColor(DesignTokens.Colors.neonPink)
                }
                
                Stepper("", value: $budget, in: 10...200, step: 5)
                    .labelsHidden()
            }
            
            Spacer()
        }
        .padding(DesignTokens.Spacing.xl)
        .background(DesignTokens.Colors.nightBlack)
        .navigationTitle("Budget")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            budget = sessionStore.currentUser?.preferences.maxBudget ?? 50.0
        }
        .onDisappear {
            // Sauvegarder les préférences
            // sessionStore.updateMaxBudget(budget)
        }
    }
}

// MARK: - App Settings View
public struct AppSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var notificationsEnabled = true
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            List {
                Section("Notifications") {
                    Toggle("Activer les notifications", isOn: $notificationsEnabled)
                        .toggleStyle(SwitchToggleStyle(tint: DesignTokens.Colors.neonPink))
                }
                .foregroundColor(DesignTokens.Colors.pureWhite)
                .listRowBackground(DesignTokens.Colors.nightBlack)
                
                Section("Application") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(DesignTokens.Colors.gray600)
                    }
                    
                    Button("Envoyer des commentaires") {
                        sendFeedback()
                    }
                }
                .foregroundColor(DesignTokens.Colors.pureWhite)
                .listRowBackground(DesignTokens.Colors.nightBlack)
            }
            .listStyle(.insetGrouped)
            .background(DesignTokens.Colors.nightBlack)
            .scrollContentBackground(.hidden)
            .navigationTitle("Paramètres")
            .navigationBarTitleDisplayMode(.large)
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
    
    private func sendFeedback() {
        if let url = URL(string: "mailto:feedback@soirees-swipe.com") {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - Previews
#Preview {
    ProfileView()
        .environmentObject(SessionStore())
} 