import Foundation
import CoreLocation
import Combine

// MARK: - Event Service Protocol
public protocol EventServiceProtocol {
    func fetchNearbyEvents(location: Coordinate?, offset: Int) async throws -> [Event]
    func fetchEventDetails(id: UUID) async throws -> Event
}

// MARK: - Event Service Implementation
public class EventService: EventServiceProtocol {
    private let session = URLSession.shared
    private let baseURL = "https://api.soirees-swipe.com/v1" // URL fictive
    
    public init() {}
    
    public func fetchNearbyEvents(location: Coordinate?, offset: Int = 0) async throws -> [Event] {
        // Pour la démonstration, retourner des données mockées
        return createMockEvents()
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
                ageRestriction: .eighteen
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
                ageRestriction: .eighteen
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
                ageRestriction: .eighteen
            )
        ]
    }
}

// MARK: - Location Manager
public class LocationManager: NSObject, ObservableObject {
    @Published public var currentLocation: CLLocation?
    @Published public var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    private let locationManager = CLLocationManager()
    
    public override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    public func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    public func startLocationUpdates() {
        guard authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways else {
            return
        }
        locationManager.startUpdatingLocation()
    }
    
    public func stopLocationUpdates() {
        locationManager.stopUpdatingLocation()
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Erreur de géolocalisation: \(error.localizedDescription)")
    }
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        
        switch authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            startLocationUpdates()
        case .denied, .restricted:
            stopLocationUpdates()
        case .notDetermined:
            requestLocationPermission()
        @unknown default:
            break
        }
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