import Foundation

// MARK: - Group Model
public struct Group: Identifiable, Codable, Hashable {
    public let id: UUID
    public let name: String
    public let imageURL: URL?
    public let members: [User]
    public let likedEvents: [UUID] // Event IDs
    public let inviteCode: String
    public let createdAt: Date
    public let createdBy: UUID // User ID
    
    public init(
        id: UUID = UUID(),
        name: String,
        imageURL: URL? = nil,
        members: [User],
        likedEvents: [UUID] = [],
        inviteCode: String = UUID().uuidString.prefix(8).uppercased(),
        createdAt: Date = Date(),
        createdBy: UUID
    ) {
        self.id = id
        self.name = name
        self.imageURL = imageURL
        self.members = members
        self.likedEvents = likedEvents
        self.inviteCode = String(inviteCode)
        self.createdAt = createdAt
        self.createdBy = createdBy
    }
}

// MARK: - User Model
public struct User: Identifiable, Codable, Hashable {
    public let id: UUID
    public let name: String
    public let email: String?
    public let avatarURL: URL?
    public let preferences: UserPreferences
    
    public init(
        id: UUID = UUID(),
        name: String,
        email: String? = nil,
        avatarURL: URL? = nil,
        preferences: UserPreferences = UserPreferences()
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.avatarURL = avatarURL
        self.preferences = preferences
    }
}

// MARK: - User Preferences
public struct UserPreferences: Codable, Hashable {
    public let musicGenres: [String]
    public let maxDistance: Double // en kilomètres
    public let maxBudget: Double // en euros
    public let notificationsEnabled: Bool
    
    public init(
        musicGenres: [String] = [],
        maxDistance: Double = 25.0,
        maxBudget: Double = 50.0,
        notificationsEnabled: Bool = true
    ) {
        self.musicGenres = musicGenres
        self.maxDistance = maxDistance
        self.maxBudget = maxBudget
        self.notificationsEnabled = notificationsEnabled
    }
}

// MARK: - Group Extensions
extension Group {
    public var memberCount: Int {
        members.count
    }
    
    public var likedEventCount: Int {
        likedEvents.count
    }
    
    public var isOwner: Bool {
        // Cette logique devrait être comparée avec l'utilisateur actuel
        // Pour l'instant, on retourne false par défaut
        false
    }
    
    public var formattedCreatedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: createdAt)
    }
}

// MARK: - Group Invite
public struct GroupInvite: Identifiable, Codable {
    public let id: UUID
    public let groupId: UUID
    public let groupName: String
    public let inviteCode: String
    public let invitedBy: User
    public let expiresAt: Date?
    
    public init(
        id: UUID = UUID(),
        groupId: UUID,
        groupName: String,
        inviteCode: String,
        invitedBy: User,
        expiresAt: Date? = nil
    ) {
        self.id = id
        self.groupId = groupId
        self.groupName = groupName
        self.inviteCode = inviteCode
        self.invitedBy = invitedBy
        self.expiresAt = expiresAt
    }
    
    public var isExpired: Bool {
        guard let expiresAt = expiresAt else { return false }
        return Date() > expiresAt
    }
} 