import SwiftUI

// MARK: - Groups View
public struct GroupsView: View {
    @EnvironmentObject private var sessionStore: SessionStore
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = GroupsViewModel()
    @State private var selectedGroup: Group?
    @State private var showingCreateGroup = false
    @State private var showingJoinGroup = false
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                headerView
                
                // Groups Horizontal List
                groupsListView
                
                // Selected Group Feed
                if let selectedGroup = selectedGroup {
                    groupFeedView(for: selectedGroup)
                } else {
                    emptySelectionView
                }
            }
            .background(DesignTokens.Colors.nightBlack)
            .navigationBarHidden(true)
            .sheet(isPresented: $showingCreateGroup) {
                CreateGroupView()
                    .environmentObject(sessionStore)
            }
            .sheet(isPresented: $showingJoinGroup) {
                JoinGroupView()
                    .environmentObject(sessionStore)
            }
            .onAppear {
                if selectedGroup == nil && !sessionStore.groups.isEmpty {
                    selectedGroup = sessionStore.groups.first
                }
            }
        }
    }
    
    // MARK: - Header View
    private var headerView: some View {
        HStack {
            Button("Fermer") {
                dismiss()
            }
            .foregroundColor(DesignTokens.Colors.pureWhite)
            
            Spacer()
            
            Text("Groupes")
                .font(DesignTokens.Typography.title)
                .foregroundColor(DesignTokens.Colors.pureWhite)
            
            Spacer()
            
            Menu {
                Button("Créer un groupe") {
                    showingCreateGroup = true
                }
                
                Button("Rejoindre un groupe") {
                    showingJoinGroup = true
                }
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(DesignTokens.Colors.neonPink)
            }
        }
        .padding(.horizontal, DesignTokens.Spacing.xl)
        .padding(.top, DesignTokens.Spacing.md)
    }
    
    // MARK: - Groups List View
    private var groupsListView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: DesignTokens.Spacing.lg) {
                ForEach(sessionStore.groups) { group in
                    GroupIconView(
                        group: group,
                        isSelected: selectedGroup?.id == group.id
                    ) {
                        selectedGroup = group
                    }
                }
            }
            .padding(.horizontal, DesignTokens.Spacing.xl)
        }
        .frame(height: 100)
        .padding(.vertical, DesignTokens.Spacing.lg)
    }
    
    // MARK: - Group Feed View
    private func groupFeedView(for group: Group) -> some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.lg) {
            // Group Info Header
            groupInfoHeader(for: group)
            
            // Events Grid
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: DesignTokens.Spacing.lg) {
                    ForEach(viewModel.likedEvents) { event in
                        MiniEventCard(event: event)
                            .matchedGeometryEffect(
                                id: event.id,
                                in: viewModel.namespace
                            )
                    }
                }
                .padding(.horizontal, DesignTokens.Spacing.xl)
                .padding(.bottom, DesignTokens.Spacing.xxl)
            }
        }
    }
    
    // MARK: - Group Info Header
    private func groupInfoHeader(for group: Group) -> some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
            HStack {
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
                    Text(group.name)
                        .font(DesignTokens.Typography.heading)
                        .foregroundColor(DesignTokens.Colors.pureWhite)
                    
                    Text("\(group.memberCount) membres • \(group.likedEventCount) événements likés")
                        .font(DesignTokens.Typography.caption)
                        .foregroundColor(DesignTokens.Colors.gray600)
                }
                
                Spacer()
                
                Menu {
                    Button("Inviter des amis") {
                        shareInviteLink(for: group)
                    }
                    
                    Button("Paramètres du groupe") {
                        // Action pour les paramètres
                    }
                    
                    if group.isOwner {
                        Button("Supprimer le groupe", role: .destructive) {
                            // Action pour supprimer
                        }
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 18))
                        .foregroundColor(DesignTokens.Colors.gray600)
                        .frame(width: 32, height: 32)
                        .background(
                            Circle()
                                .fill(DesignTokens.Colors.gray600.opacity(0.1))
                        )
                }
            }
            
            // Members Preview
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: DesignTokens.Spacing.sm) {
                    ForEach(group.members.prefix(5)) { member in
                        MemberAvatarView(member: member)
                    }
                    
                    if group.members.count > 5 {
                        Text("+\(group.members.count - 5)")
                            .font(DesignTokens.Typography.caption)
                            .foregroundColor(DesignTokens.Colors.gray600)
                            .frame(width: 32, height: 32)
                            .background(
                                Circle()
                                    .fill(DesignTokens.Colors.gray600.opacity(0.3))
                            )
                    }
                }
                .padding(.horizontal, 1)
            }
        }
        .padding(.horizontal, DesignTokens.Spacing.xl)
    }
    
    // MARK: - Empty Selection View
    private var emptySelectionView: some View {
        VStack(spacing: DesignTokens.Spacing.xl) {
            Image(systemName: "person.3")
                .font(.system(size: 60))
                .foregroundColor(DesignTokens.Colors.neonBlue)
            
            VStack(spacing: DesignTokens.Spacing.md) {
                Text("Aucun groupe sélectionné")
                    .font(DesignTokens.Typography.heading)
                    .foregroundColor(DesignTokens.Colors.pureWhite)
                
                Text("Créez votre premier groupe ou rejoignez-en un pour partager vos événements préférés !")
                    .font(DesignTokens.Typography.body)
                    .foregroundColor(DesignTokens.Colors.gray600)
                    .multilineTextAlignment(.center)
            }
            
            HStack(spacing: DesignTokens.Spacing.lg) {
                Button("Créer un groupe") {
                    showingCreateGroup = true
                }
                .font(DesignTokens.Typography.body)
                .foregroundColor(DesignTokens.Colors.pureWhite)
                .padding(.horizontal, DesignTokens.Spacing.xl)
                .padding(.vertical, DesignTokens.Spacing.lg)
                .background(
                    RoundedRectangle(cornerRadius: DesignTokens.Radius.button)
                        .fill(DesignTokens.Colors.neonPink)
                )
                
                Button("Rejoindre") {
                    showingJoinGroup = true
                }
                .font(DesignTokens.Typography.body)
                .foregroundColor(DesignTokens.Colors.neonBlue)
                .padding(.horizontal, DesignTokens.Spacing.xl)
                .padding(.vertical, DesignTokens.Spacing.lg)
                .background(
                    RoundedRectangle(cornerRadius: DesignTokens.Radius.button)
                        .stroke(DesignTokens.Colors.neonBlue, lineWidth: 2)
                )
            }
        }
        .padding(DesignTokens.Spacing.xxl)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Private Methods
    private func shareInviteLink(for group: Group) {
        let inviteURL = "https://soirees-swipe.com/invite/\(group.inviteCode)"
        let activityViewController = UIActivityViewController(
            activityItems: [inviteURL],
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(activityViewController, animated: true)
        }
    }
}

// MARK: - Group Icon View
struct GroupIconView: View {
    let group: Group
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: DesignTokens.Spacing.sm) {
                AsyncImage(url: group.imageURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Image(systemName: "person.3.fill")
                        .font(.system(size: 24))
                        .foregroundColor(DesignTokens.Colors.neonBlue)
                }
                .frame(width: 60, height: 60)
                .background(DesignTokens.Colors.gray600.opacity(0.3))
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(
                            isSelected ? DesignTokens.Colors.neonPink : DesignTokens.Colors.gray600.opacity(0.3),
                            lineWidth: isSelected ? 3 : 1
                        )
                )
                
                Text(group.name)
                    .font(DesignTokens.Typography.caption)
                    .foregroundColor(isSelected ? DesignTokens.Colors.neonPink : DesignTokens.Colors.pureWhite)
                    .lineLimit(1)
                    .frame(width: 70)
            }
        }
        .scaleEffect(isSelected ? 1.1 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

// MARK: - Mini Event Card
struct MiniEventCard: View {
    let event: Event
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.sm) {
            AsyncImage(url: event.imageURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(DesignTokens.Colors.gray600.opacity(0.3))
                    .overlay(
                        Image(systemName: "photo")
                            .font(.system(size: 20))
                            .foregroundColor(DesignTokens.Colors.gray600)
                    )
            }
            .frame(height: 120)
            .clipped()
            .cornerRadius(DesignTokens.Radius.button)
            
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
                Text(event.title)
                    .font(DesignTokens.Typography.body)
                    .fontWeight(.semibold)
                    .foregroundColor(DesignTokens.Colors.pureWhite)
                    .lineLimit(2)
                
                Text(event.location.name)
                    .font(DesignTokens.Typography.caption)
                    .foregroundColor(DesignTokens.Colors.gray600)
                    .lineLimit(1)
                
                HStack {
                    if let price = event.price {
                        Text(price.formatted)
                            .font(DesignTokens.Typography.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(DesignTokens.Colors.neonPink)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "heart.fill")
                        .font(.system(size: 12))
                        .foregroundColor(DesignTokens.Colors.neonPink)
                }
            }
            .padding(.horizontal, DesignTokens.Spacing.sm)
            .padding(.bottom, DesignTokens.Spacing.sm)
        }
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

// MARK: - Member Avatar View
struct MemberAvatarView: View {
    let member: User
    
    var body: some View {
        AsyncImage(url: member.avatarURL) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
        } placeholder: {
            Image(systemName: "person.fill")
                .font(.system(size: 16))
                .foregroundColor(DesignTokens.Colors.pureWhite)
        }
        .frame(width: 32, height: 32)
        .background(DesignTokens.Colors.gray600)
        .clipShape(Circle())
        .overlay(
            Circle()
                .stroke(DesignTokens.Colors.nightBlack, lineWidth: 2)
        )
    }
}

// MARK: - Groups View Model
@MainActor
public class GroupsViewModel: ObservableObject {
    @Published public var likedEvents: [Event] = []
    public let namespace = Namespace().wrappedValue
    
    public init() {
        loadMockLikedEvents()
    }
    
    private func loadMockLikedEvents() {
        // Données mockées pour la démonstration
        likedEvents = [
            Event(
                title: "Techno Night",
                description: "Soirée techno",
                imageURL: URL(string: "https://example.com/event1.jpg"),
                date: Date(),
                location: EventLocation(
                    name: "La Bellevilloise",
                    address: "Paris",
                    city: "Paris",
                    coordinate: Coordinate(latitude: 48.8566, longitude: 2.3522)
                ),
                lineup: [],
                genres: ["Techno"],
                price: Price(amount: 25.0),
                ticketURL: nil,
                distance: 2.3
            ),
            Event(
                title: "House Festival",
                description: "Festival house",
                imageURL: URL(string: "https://example.com/event2.jpg"),
                date: Date(),
                location: EventLocation(
                    name: "Zigzag Club",
                    address: "Paris",
                    city: "Paris",
                    coordinate: Coordinate(latitude: 48.8698, longitude: 2.3048)
                ),
                lineup: [],
                genres: ["House"],
                price: Price(amount: 35.0),
                ticketURL: nil,
                distance: 1.8
            )
        ]
    }
}

// MARK: - Create Group View
struct CreateGroupView: View {
    @EnvironmentObject private var sessionStore: SessionStore
    @Environment(\.dismiss) private var dismiss
    @State private var groupName = ""
    @State private var groupDescription = ""
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.xl) {
                Text("Créer un nouveau groupe")
                    .font(DesignTokens.Typography.title)
                    .foregroundColor(DesignTokens.Colors.pureWhite)
                
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.lg) {
                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
                        Text("Nom du groupe")
                            .font(DesignTokens.Typography.body)
                            .foregroundColor(DesignTokens.Colors.pureWhite)
                        
                        TextField("Ex: Les Fêtards", text: $groupName)
                            .textFieldStyle(CustomTextFieldStyle())
                    }
                    
                    VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
                        Text("Description (optionnel)")
                            .font(DesignTokens.Typography.body)
                            .foregroundColor(DesignTokens.Colors.pureWhite)
                        
                        TextField("Décrivez votre groupe...", text: $groupDescription, axis: .vertical)
                            .textFieldStyle(CustomTextFieldStyle())
                            .lineLimit(3...6)
                    }
                }
                
                Spacer()
                
                Button("Créer le groupe") {
                    createGroup()
                }
                .font(DesignTokens.Typography.body)
                .fontWeight(.semibold)
                .foregroundColor(DesignTokens.Colors.pureWhite)
                .frame(maxWidth: .infinity)
                .padding(.vertical, DesignTokens.Spacing.lg)
                .background(
                    RoundedRectangle(cornerRadius: DesignTokens.Radius.button)
                        .fill(groupName.isEmpty ? DesignTokens.Colors.gray600 : DesignTokens.Colors.neonPink)
                )
                .disabled(groupName.isEmpty)
            }
            .padding(DesignTokens.Spacing.xl)
            .background(DesignTokens.Colors.nightBlack)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Annuler") {
                        dismiss()
                    }
                    .foregroundColor(DesignTokens.Colors.pureWhite)
                }
            }
        }
    }
    
    private func createGroup() {
        // Implémentation de la création de groupe
        dismiss()
    }
}

// MARK: - Join Group View
struct JoinGroupView: View {
    @EnvironmentObject private var sessionStore: SessionStore
    @Environment(\.dismiss) private var dismiss
    @State private var inviteCode = ""
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: DesignTokens.Spacing.xl) {
                Text("Rejoindre un groupe")
                    .font(DesignTokens.Typography.title)
                    .foregroundColor(DesignTokens.Colors.pureWhite)
                
                VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
                    Text("Code d'invitation")
                        .font(DesignTokens.Typography.body)
                        .foregroundColor(DesignTokens.Colors.pureWhite)
                    
                    TextField("Ex: ABC12345", text: $inviteCode)
                        .textFieldStyle(CustomTextFieldStyle())
                        .textCase(.uppercase)
                }
                
                Spacer()
                
                Button("Rejoindre") {
                    joinGroup()
                }
                .font(DesignTokens.Typography.body)
                .fontWeight(.semibold)
                .foregroundColor(DesignTokens.Colors.pureWhite)
                .frame(maxWidth: .infinity)
                .padding(.vertical, DesignTokens.Spacing.lg)
                .background(
                    RoundedRectangle(cornerRadius: DesignTokens.Radius.button)
                        .fill(inviteCode.isEmpty ? DesignTokens.Colors.gray600 : DesignTokens.Colors.neonBlue)
                )
                .disabled(inviteCode.isEmpty)
            }
            .padding(DesignTokens.Spacing.xl)
            .background(DesignTokens.Colors.nightBlack)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Annuler") {
                        dismiss()
                    }
                    .foregroundColor(DesignTokens.Colors.pureWhite)
                }
            }
        }
    }
    
    private func joinGroup() {
        // Implémentation pour rejoindre un groupe
        dismiss()
    }
}

// MARK: - Custom Text Field Style
struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(DesignTokens.Typography.body)
            .foregroundColor(DesignTokens.Colors.pureWhite)
            .padding(DesignTokens.Spacing.lg)
            .background(
                RoundedRectangle(cornerRadius: DesignTokens.Radius.button)
                    .fill(DesignTokens.Colors.gray600.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: DesignTokens.Radius.button)
                            .stroke(DesignTokens.Colors.gray600.opacity(0.3), lineWidth: 1)
                    )
            )
    }
}

// MARK: - Previews
#Preview {
    GroupsView()
        .environmentObject(SessionStore())
} 