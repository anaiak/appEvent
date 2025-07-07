import SwiftUI

// MARK: - Groups View
// Vue de gestion des groupes d'amis selon specs design

public struct GroupsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var groups: [Group] = Group.mockGroups
    @State private var showingCreateGroup = false
    @State private var selectedGroup: Group?
    @State private var searchText = ""
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search bar
                searchBar
                
                // Content
                if filteredGroups.isEmpty {
                    emptyStateView
                } else {
                    groupsList
                }
            }
            .background(DesignTokens.Colors.nightBlack)
            .navigationTitle("Groupes")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Fermer") {
                        dismiss()
                    }
                    .foregroundStyle(DesignTokens.Colors.neonPink)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingCreateGroup = true
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(DesignTokens.Colors.neonBlue)
                    }
                }
            }
        }
        .sheet(isPresented: $showingCreateGroup) {
            CreateGroupView(onCreateGroup: { newGroup in
                groups.append(newGroup)
                showingCreateGroup = false
            })
        }
        .sheet(item: $selectedGroup) { group in
            GroupDetailView(group: group)
        }
    }
    
    // MARK: - Search Bar
    private var searchBar: some View {
        HStack(spacing: DesignTokens.Spacing.sm) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 16))
                .foregroundStyle(DesignTokens.Colors.gray600)
            
            TextField("Rechercher un groupe...", text: $searchText)
                .font(DesignTokens.Typography.bodyFont)
                .foregroundStyle(DesignTokens.Colors.pureWhite)
                .tint(DesignTokens.Colors.neonPink)
            
            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 16))
                        .foregroundStyle(DesignTokens.Colors.gray600)
                }
            }
        }
        .padding(DesignTokens.Spacing.md)
        .background(DesignTokens.Colors.backgroundSecondary)
        .clipShape(RoundedRectangle(cornerRadius: DesignTokens.Radius.button))
        .padding(.horizontal, DesignTokens.Spacing.lg)
        .padding(.top, DesignTokens.Spacing.md)
    }
    
    // MARK: - Groups List
    private var groupsList: some View {
        ScrollView {
            LazyVStack(spacing: DesignTokens.Spacing.md) {
                ForEach(filteredGroups) { group in
                    GroupCard(group: group) {
                        selectedGroup = group
                    }
                }
            }
            .padding(DesignTokens.Spacing.lg)
        }
    }
    
    // MARK: - Empty State
    private var emptyStateView: some View {
        VStack(spacing: DesignTokens.Spacing.xl) {
            Spacer()
            
            // Illustration
            ZStack {
                Image(systemName: "person.3.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(DesignTokens.Colors.neonBlue)
                    .blur(radius: 10)
                    .opacity(0.6)
                
                Image(systemName: "person.3.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(DesignTokens.Colors.neonBlue)
            }
            
            // Text
            VStack(spacing: DesignTokens.Spacing.md) {
                Text(searchText.isEmpty ? "Aucun groupe" : "Aucun résultat")
                    .font(DesignTokens.Typography.titleFont)
                    .foregroundStyle(DesignTokens.Colors.pureWhite)
                
                Text(searchText.isEmpty ? 
                     "Créez votre premier groupe pour partager vos soirées préférées avec vos amis !" :
                     "Aucun groupe ne correspond à votre recherche."
                )
                .font(DesignTokens.Typography.bodyFont)
                .foregroundStyle(DesignTokens.Colors.gray600)
                .multilineTextAlignment(.center)
                .padding(.horizontal, DesignTokens.Spacing.xl)
            }
            
            // Create button (only for empty state)
            if searchText.isEmpty {
                Button(action: {
                    showingCreateGroup = true
                }) {
                    HStack {
                        Image(systemName: "plus")
                            .font(DesignTokens.Typography.headingFont)
                        Text("Créer un groupe")
                            .font(DesignTokens.Typography.headingFont)
                    }
                    .foregroundStyle(DesignTokens.Colors.pureWhite)
                    .padding(.horizontal, DesignTokens.Spacing.lg)
                    .padding(.vertical, DesignTokens.Spacing.md)
                    .background(DesignTokens.Colors.neonBlue)
                    .clipShape(RoundedRectangle(cornerRadius: DesignTokens.Radius.button))
                }
                .padding(.top, DesignTokens.Spacing.lg)
            }
            
            Spacer()
        }
        .padding(DesignTokens.Spacing.lg)
    }
    
    // MARK: - Computed Properties
    private var filteredGroups: [Group] {
        if searchText.isEmpty {
            return groups
        }
        return groups.filter { group in
            group.name.localizedCaseInsensitiveContains(searchText) ||
            group.description?.localizedCaseInsensitiveContains(searchText) == true
        }
    }
}

// MARK: - Group Card
private struct GroupCard: View {
    let group: Group
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: DesignTokens.Spacing.md) {
                // Group avatar
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    DesignTokens.Colors.neonBlue.opacity(0.8),
                                    DesignTokens.Colors.neonPink.opacity(0.8)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: "person.3.fill")
                        .font(.system(size: 28))
                        .foregroundStyle(DesignTokens.Colors.pureWhite)
                }
                
                // Group info
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                    HStack {
                        Text(group.name)
                            .font(DesignTokens.Typography.headingFont)
                            .foregroundStyle(DesignTokens.Colors.pureWhite)
                            .lineLimit(1)
                        
                        Spacer()
                        
                        if group.isPrivate {
                            Image(systemName: "lock.fill")
                                .font(.system(size: 12))
                                .foregroundStyle(DesignTokens.Colors.warningColor)
                        }
                    }
                    
                    if let description = group.description {
                        Text(description)
                            .font(DesignTokens.Typography.captionFont)
                            .foregroundStyle(DesignTokens.Colors.gray600)
                            .lineLimit(2)
                    }
                    
                    HStack(spacing: DesignTokens.Spacing.lg) {
                        // Members count
                        HStack(spacing: DesignTokens.Spacing.xs) {
                            Image(systemName: "person.fill")
                                .font(.system(size: 12))
                                .foregroundStyle(DesignTokens.Colors.neonBlue)
                            Text("\(group.memberCount) membres")
                                .font(DesignTokens.Typography.captionFont)
                                .foregroundStyle(DesignTokens.Colors.gray600)
                        }
                        
                        // Activity indicator
                        if group.hasRecentActivity {
                            HStack(spacing: DesignTokens.Spacing.xs) {
                                Circle()
                                    .fill(DesignTokens.Colors.successColor)
                                    .frame(width: 6, height: 6)
                                Text("Actif")
                                    .font(.system(size: 11))
                                    .foregroundStyle(DesignTokens.Colors.successColor)
                            }
                        }
                        
                        Spacer()
                    }
                }
                
                // Chevron
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(DesignTokens.Colors.gray600)
            }
            .padding(DesignTokens.Spacing.md)
            .background(DesignTokens.Colors.backgroundSecondary)
            .clipShape(RoundedRectangle(cornerRadius: DesignTokens.Radius.card))
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Create Group View
private struct CreateGroupView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var groupName = ""
    @State private var groupDescription = ""
    @State private var isPrivate = false
    
    let onCreateGroup: (Group) -> Void
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: DesignTokens.Spacing.xl) {
                    // Header
                    VStack(spacing: DesignTokens.Spacing.md) {
                        ZStack {
                            Circle()
                                .fill(DesignTokens.Colors.neonBlue.opacity(0.2))
                                .frame(width: 100, height: 100)
                            
                            Image(systemName: "person.3.fill")
                                .font(.system(size: 50))
                                .foregroundStyle(DesignTokens.Colors.neonBlue)
                        }
                        
                        Text("Créer un groupe")
                            .font(DesignTokens.Typography.titleFont)
                            .foregroundStyle(DesignTokens.Colors.pureWhite)
                    }
                    
                    // Form
                    VStack(spacing: DesignTokens.Spacing.lg) {
                        // Group name
                        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                            Text("Nom du groupe")
                                .font(DesignTokens.Typography.bodyFont)
                                .foregroundStyle(DesignTokens.Colors.pureWhite)
                            
                            TextField("Ex: Les amis de la tech", text: $groupName)
                                .font(DesignTokens.Typography.bodyFont)
                                .foregroundStyle(DesignTokens.Colors.pureWhite)
                                .padding(DesignTokens.Spacing.md)
                                .background(DesignTokens.Colors.backgroundSecondary)
                                .clipShape(RoundedRectangle(cornerRadius: DesignTokens.Radius.button))
                                .tint(DesignTokens.Colors.neonPink)
                        }
                        
                        // Description
                        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                            Text("Description (optionnel)")
                                .font(DesignTokens.Typography.bodyFont)
                                .foregroundStyle(DesignTokens.Colors.pureWhite)
                            
                            TextField("Décrivez votre groupe...", text: $groupDescription, axis: .vertical)
                                .font(DesignTokens.Typography.bodyFont)
                                .foregroundStyle(DesignTokens.Colors.pureWhite)
                                .padding(DesignTokens.Spacing.md)
                                .background(DesignTokens.Colors.backgroundSecondary)
                                .clipShape(RoundedRectangle(cornerRadius: DesignTokens.Radius.button))
                                .lineLimit(3...6)
                                .tint(DesignTokens.Colors.neonPink)
                        }
                        
                        // Privacy toggle
                        HStack {
                            VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                                Text("Groupe privé")
                                    .font(DesignTokens.Typography.bodyFont)
                                    .foregroundStyle(DesignTokens.Colors.pureWhite)
                                
                                Text("Seuls les membres invités peuvent rejoindre")
                                    .font(DesignTokens.Typography.captionFont)
                                    .foregroundStyle(DesignTokens.Colors.gray600)
                            }
                            
                            Spacer()
                            
                            Toggle("", isOn: $isPrivate)
                                .tint(DesignTokens.Colors.neonPink)
                        }
                        .padding(DesignTokens.Spacing.md)
                        .background(DesignTokens.Colors.backgroundSecondary)
                        .clipShape(RoundedRectangle(cornerRadius: DesignTokens.Radius.button))
                    }
                    
                    Spacer()
                    
                    // Create button
                    Button(action: createGroup) {
                        Text("Créer le groupe")
                            .font(DesignTokens.Typography.headingFont)
                            .foregroundStyle(DesignTokens.Colors.pureWhite)
                            .frame(maxWidth: .infinity)
                            .padding(DesignTokens.Spacing.md)
                            .background(
                                LinearGradient(
                                    colors: [
                                        DesignTokens.Colors.neonBlue,
                                        DesignTokens.Colors.neonPink
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: DesignTokens.Radius.button))
                    }
                    .disabled(groupName.isEmpty)
                    .opacity(groupName.isEmpty ? 0.6 : 1.0)
                }
                .padding(DesignTokens.Spacing.lg)
            }
            .background(DesignTokens.Colors.nightBlack)
            .navigationTitle("Nouveau groupe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Annuler") {
                        dismiss()
                    }
                    .foregroundStyle(DesignTokens.Colors.gray600)
                }
            }
        }
    }
    
    private func createGroup() {
        let newGroup = Group(
            id: UUID(),
            name: groupName,
            description: groupDescription.isEmpty ? nil : groupDescription,
            memberCount: 1,
            isPrivate: isPrivate,
            hasRecentActivity: false,
            createdAt: Date()
        )
        
        DesignTokens.Haptics.success.notificationOccurred(.success)
        onCreateGroup(newGroup)
    }
}

// MARK: - Group Detail View
private struct GroupDetailView: View {
    let group: Group
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: DesignTokens.Spacing.xl) {
                    // Header
                    VStack(spacing: DesignTokens.Spacing.lg) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            DesignTokens.Colors.neonBlue.opacity(0.8),
                                            DesignTokens.Colors.neonPink.opacity(0.8)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 120, height: 120)
                            
                            Image(systemName: "person.3.fill")
                                .font(.system(size: 60))
                                .foregroundStyle(DesignTokens.Colors.pureWhite)
                        }
                        
                        VStack(spacing: DesignTokens.Spacing.sm) {
                            HStack {
                                Text(group.name)
                                    .font(DesignTokens.Typography.titleFont)
                                    .foregroundStyle(DesignTokens.Colors.pureWhite)
                                
                                if group.isPrivate {
                                    Image(systemName: "lock.fill")
                                        .font(.system(size: 16))
                                        .foregroundStyle(DesignTokens.Colors.warningColor)
                                }
                            }
                            
                            if let description = group.description {
                                Text(description)
                                    .font(DesignTokens.Typography.bodyFont)
                                    .foregroundStyle(DesignTokens.Colors.gray600)
                                    .multilineTextAlignment(.center)
                            }
                            
                            Text("\(group.memberCount) membres")
                                .font(DesignTokens.Typography.captionFont)
                                .foregroundStyle(DesignTokens.Colors.neonBlue)
                        }
                    }
                    
                    // Actions
                    VStack(spacing: DesignTokens.Spacing.md) {
                        Button(action: {
                            // TODO: Invite members
                        }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                    .font(DesignTokens.Typography.headingFont)
                                Text("Inviter des amis")
                                    .font(DesignTokens.Typography.headingFont)
                            }
                            .foregroundStyle(DesignTokens.Colors.pureWhite)
                            .frame(maxWidth: .infinity)
                            .padding(DesignTokens.Spacing.md)
                            .background(DesignTokens.Colors.neonBlue)
                            .clipShape(RoundedRectangle(cornerRadius: DesignTokens.Radius.button))
                        }
                        
                        Button(action: {
                            // TODO: Share group events
                        }) {
                            HStack {
                                Image(systemName: "heart.circle.fill")
                                    .font(DesignTokens.Typography.headingFont)
                                Text("Événements partagés")
                                    .font(DesignTokens.Typography.headingFont)
                            }
                            .foregroundStyle(DesignTokens.Colors.pureWhite)
                            .frame(maxWidth: .infinity)
                            .padding(DesignTokens.Spacing.md)
                            .background(DesignTokens.Colors.neonPink)
                            .clipShape(RoundedRectangle(cornerRadius: DesignTokens.Radius.button))
                        }
                    }
                    
                    Spacer()
                }
                .padding(DesignTokens.Spacing.lg)
            }
            .background(DesignTokens.Colors.nightBlack)
            .navigationTitle("Détails du groupe")
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
#Preview("Groups View") {
    GroupsView()
        .preferredColorScheme(.dark)
}

#Preview("Create Group") {
    CreateGroupView(onCreateGroup: { _ in })
        .preferredColorScheme(.dark)
}

#Preview("Group Detail") {
    GroupDetailView(group: Group.mockGroups[0])
        .preferredColorScheme(.dark)
} 