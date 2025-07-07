import Foundation
import CoreLocation
import Combine

// MARK: - Event Service Protocol
public protocol EventServiceProtocol {
    func fetchNearbyEvents(location: CLLocation?, offset: Int) async throws -> [Event]
    func fetchEventDetails(id: UUID) async throws -> Event
}

// MARK: - Event Service Implementation
public class EventService: EventServiceProtocol {
    
    public init() {}
    
    public func fetchNearbyEvents(location: CLLocation?, offset: Int = 0) async throws -> [Event] {
        // Simule un délai de réseau
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 secondes
        
        // Retourne les événements mockés avec pagination
        let allEvents = createMockEvents()
        let startIndex = offset
        let endIndex = min(offset + 10, allEvents.count)
        
        guard startIndex < allEvents.count else { return [] }
        
        return Array(allEvents[startIndex..<endIndex])
    }
    
    public func fetchEventDetails(id: UUID) async throws -> Event {
        // Pour la démonstration, retourner un événement mocké
        let mockEvents = createMockEvents()
        return mockEvents.first { $0.id == id } ?? mockEvents[0]
    }
    
    // MARK: - Mock Data
    private func createMockEvents() -> [Event] {
        [
            Event(
                title: "Techno Night à La Bellevilloise",
                description: "Une soirée techno inoubliable avec des DJs internationaux dans le cadre mythique de La Bellevilloise.",
                imageURL: "https://example.com/event1.jpg",
                date: Date().addingTimeInterval(3600 * 24 * 2), // Dans 2 jours
                venue: Venue(
                    name: "La Bellevilloise",
                    address: "19-21 Rue Boyer",
                    city: "Paris",
                    postalCode: "75020",
                    coordinate: Coordinate(latitude: 48.8566, longitude: 2.3522),
                    distance: 2.3
                ),
                organizer: Organizer(
                    name: "La Bellevilloise",
                    verified: true
                ),
                musicGenres: [.techno, .electronic],
                ticketInfo: TicketInfo(
                    minPrice: 25.0,
                    maxPrice: 35.0
                ),
                lineup: [
                    Artist(name: "Charlotte de Witte", genres: [.techno]),
                    Artist(name: "Amelie Lens", genres: [.techno]),
                    Artist(name: "I Hate Models", genres: [.techno])
                ],
                ageRestriction: .eighteenPlus
            ),
            Event(
                title: "Hip-Hop Session au Supersonic",
                description: "Les meilleurs rappeurs français se retrouvent pour une session hip-hop exclusive.",
                imageURL: "https://example.com/event2.jpg",
                date: Date().addingTimeInterval(3600 * 24 * 5), // Dans 5 jours
                venue: Venue(
                    name: "Le Supersonic",
                    address: "9 Rue Biscornet",
                    city: "Paris",
                    postalCode: "75012",
                    coordinate: Coordinate(latitude: 48.8503, longitude: 2.3672),
                    distance: 4.1
                ),
                organizer: Organizer(
                    name: "Le Supersonic",
                    verified: true
                ),
                musicGenres: [.hiphop, .rap],
                ticketInfo: TicketInfo(
                    minPrice: 30.0,
                    maxPrice: 40.0
                ),
                lineup: [
                    Artist(name: "Nekfeu", genres: [.hiphop]),
                    Artist(name: "Alpha Wann", genres: [.rap])
                ],
                ageRestriction: .eighteenPlus
            ),
            Event(
                title: "House Music Festival",
                description: "Un festival de house music avec les meilleurs DJs de la scène parisienne.",
                imageURL: "https://example.com/event3.jpg",
                date: Date().addingTimeInterval(3600 * 24 * 7), // Dans 7 jours
                venue: Venue(
                    name: "Zigzag Club",
                    address: "32 Rue Marbeuf",
                    city: "Paris",
                    postalCode: "75008",
                    coordinate: Coordinate(latitude: 48.8698, longitude: 2.3048),
                    distance: 1.8
                ),
                organizer: Organizer(
                    name: "Zigzag Club",
                    verified: true
                ),
                musicGenres: [.house, .techHouse],
                ticketInfo: TicketInfo(
                    minPrice: 35.0,
                    maxPrice: 45.0
                ),
                lineup: [
                    Artist(name: "Disclosure", genres: [.house]),
                    Artist(name: "CamelPhat", genres: [.techHouse])
                ],
                ageRestriction: .eighteenPlus
            ),
            Event(
                title: "Electronic Vibes",
                description: "Une soirée électronique avec des sons innovants et des visuels époustouflants.",
                imageURL: "https://example.com/event4.jpg",
                date: Date().addingTimeInterval(3600 * 24 * 10), // Dans 10 jours
                venue: Venue(
                    name: "Rex Club",
                    address: "5 Boulevard Poissonnière",
                    city: "Paris",
                    postalCode: "75002",
                    coordinate: Coordinate(latitude: 48.8719, longitude: 2.3468),
                    distance: 3.2
                ),
                organizer: Organizer(
                    name: "Rex Club",
                    verified: true
                ),
                musicGenres: [.electronic, .minimal],
                ticketInfo: TicketInfo(
                    minPrice: 20.0,
                    maxPrice: 30.0
                ),
                lineup: [
                    Artist(name: "Moderat", genres: [.electronic]),
                    Artist(name: "Max Richter", genres: [.ambient])
                ],
                ageRestriction: .eighteenPlus
            )
        ]
    }
}

// MARK: - Session Store
@MainActor
public class SessionStore: ObservableObject {
    @Published public var currentUser: User?
    @Published public var isAuthenticated: Bool = false
    @Published public var groups: [Group] = []
    
    public init() {
        // Simulation d'un utilisateur connecté
        loadMockUser()
    }
    
    private func loadMockUser() {
        currentUser = User(
            name: "Jean Dupont",
            email: "jean.dupont@example.com",
            preferences: UserPreferences(
                musicGenres: [.techno, .house, .hiphop],
                maxDistance: 25.0,
                maxBudget: 50.0
            )
        )
        isAuthenticated = true
        
        // Groupes de démonstration
        groups = [
            Group(
                name: "Les Fêtards",
                members: [currentUser!],
                createdBy: currentUser!.id
            ),
            Group(
                name: "Techno Lovers",
                members: [currentUser!],
                createdBy: currentUser!.id
            )
        ]
    }
    
    public func signOut() {
        currentUser = nil
        isAuthenticated = false
        groups = []
    }
} 