import SwiftUI
import Combine
import CoreLocation

// MARK: - Swipe View Model
// ViewModel principal pour gérer le deck d'événements et les interactions swipe

@MainActor
public final class SwipeViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published public var events: [Event] = []
    @Published public var currentEventIndex: Int = 0
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String?
    @Published public var hasMoreEvents: Bool = true
    
    // MARK: - Private Properties
    private let eventService: EventServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    private let maxEventsInDeck: Int = 5
    
    // MARK: - Computed Properties
    public var currentEvent: Event? {
        guard currentEventIndex < events.count else { return nil }
        return events[currentEventIndex]
    }
    
    public var nextEvent: Event? {
        let nextIndex = currentEventIndex + 1
        guard nextIndex < events.count else { return nil }
        return events[nextIndex]
    }
    
    public var hasCurrentEvent: Bool {
        currentEvent != nil
    }
    
    public var eventsInDeck: [Event] {
        let endIndex = min(currentEventIndex + maxEventsInDeck, events.count)
        guard currentEventIndex < endIndex else { return [] }
        return Array(events[currentEventIndex..<endIndex])
    }
    
    public var progress: Double {
        guard !events.isEmpty else { return 0 }
        return Double(currentEventIndex) / Double(events.count)
    }
    
    // MARK: - Initialization
    public init(eventService: EventServiceProtocol = EventService()) {
        self.eventService = eventService
        setupErrorHandling()
    }
    
    // MARK: - Public Methods
    
    /// Charge les événements initiaux
    public func loadEvents() async {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let newEvents = try await eventService.fetchEvents(limit: 20)
            self.events = newEvents
            self.currentEventIndex = 0
            self.hasMoreEvents = newEvents.count >= 20
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    /// Charge plus d'événements quand nécessaire
    public func loadMoreEventsIfNeeded() async {
        // Charge plus d'événements quand il reste seulement 3 cartes
        let remainingEvents = events.count - currentEventIndex
        guard remainingEvents <= 3 && hasMoreEvents && !isLoading else { return }
        
        await loadMoreEvents()
    }
    
    /// Like un événement et passe au suivant
    public func likeEvent() async {
        guard let event = currentEvent else { return }
        
        // Haptic feedback success
        await MainActor.run {
            DesignTokens.Haptics.success.notificationOccurred(.success)
        }
        
        do {
            try await eventService.likeEvent(event.id)
            await moveToNextEvent()
        } catch {
            errorMessage = "Erreur lors du like: \(error.localizedDescription)"
        }
    }
    
    /// Passe un événement et passe au suivant
    public func passEvent() async {
        guard let event = currentEvent else { return }
        
        // Haptic feedback medium
        await MainActor.run {
            DesignTokens.Haptics.medium.impactOccurred()
        }
        
        do {
            try await eventService.passEvent(event.id)
            await moveToNextEvent()
        } catch {
            errorMessage = "Erreur lors du pass: \(error.localizedDescription)"
        }
    }
    
    /// Recharge complètement les événements
    public func refresh() async {
        events.removeAll()
        currentEventIndex = 0
        hasMoreEvents = true
        await loadEvents()
    }
    
    /// Revient à l'événement précédent (si possible)
    public func undoLastAction() {
        guard currentEventIndex > 0 else { return }
        currentEventIndex -= 1
        DesignTokens.Haptics.selection.selectionChanged()
    }
    
    // MARK: - Private Methods
    
    private func moveToNextEvent() async {
        currentEventIndex += 1
        
        // Charge plus d'événements si nécessaire
        await loadMoreEventsIfNeeded()
    }
    
    private func loadMoreEvents() async {
        guard !isLoading else { return }
        
        isLoading = true
        
        do {
            let offset = events.count
            let newEvents = try await eventService.fetchEvents(limit: 10, offset: offset)
            
            if newEvents.isEmpty {
                hasMoreEvents = false
            } else {
                events.append(contentsOf: newEvents)
                hasMoreEvents = newEvents.count >= 10
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    private func setupErrorHandling() {
        // Auto-clear error messages après 5 secondes
        $errorMessage
            .compactMap { $0 }
            .delay(for: .seconds(5), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.errorMessage = nil
            }
            .store(in: &cancellables)
    }
}

// MARK: - Event Service Protocol
public protocol EventServiceProtocol {
    func fetchEvents(limit: Int, offset: Int) async throws -> [Event]
    func likeEvent(_ eventId: UUID) async throws
    func passEvent(_ eventId: UUID) async throws
}

// MARK: - Mock Event Service
public final class EventService: EventServiceProtocol {
    
    public init() {}
    
    public func fetchEvents(limit: Int = 20, offset: Int = 0) async throws -> [Event] {
        // Simule un délai de réseau
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 secondes
        
        // Pour le mock, on duplique les événements de base
        let baseEvents = Event.mockEvents
        var allEvents: [Event] = []
        
        // Génère plus d'événements en variant les données
        for i in 0..<(limit + offset + 10) {
            let baseIndex = i % baseEvents.count
            var event = baseEvents[baseIndex]
            
            // Varie les données pour créer de la diversité
            let variations = [
                "Underground Session #\(i + 1)",
                "Techno Night Vol.\(i + 1)",
                "House Music Experience #\(i + 1)",
                "Electronic Vibes #\(i + 1)",
                "Festival Experience #\(i + 1)"
            ]
            
            let cities = ["Paris", "Lyon", "Marseille", "Toulouse", "Bordeaux"]
            let distances = [0.5, 1.2, 2.8, 3.5, 4.1, 5.9, 7.2, 8.8]
            
            // Crée un nouvel événement avec des variations
            event = Event(
                id: UUID(),
                title: variations[i % variations.count],
                description: event.description,
                imageURL: event.imageURL,
                date: Calendar.current.date(byAdding: .day, value: i % 14, to: Date()) ?? event.date,
                venue: Venue(
                    name: event.venue.name,
                    address: event.venue.address,
                    city: cities[i % cities.count],
                    postalCode: event.venue.postalCode,
                    coordinate: event.venue.coordinate,
                    distance: distances[i % distances.count]
                ),
                organizer: event.organizer,
                musicGenres: event.musicGenres,
                ticketInfo: TicketInfo(
                    minPrice: Double.random(in: 10...50),
                    maxPrice: Double.random(in: 50...80)
                ),
                lineup: event.lineup,
                ageRestriction: event.ageRestriction,
                attendeeCount: Int.random(in: 50...1500)
            )
            
            allEvents.append(event)
        }
        
        // Retourne la slice demandée
        let startIndex = offset
        let endIndex = min(offset + limit, allEvents.count)
        
        guard startIndex < allEvents.count else { return [] }
        
        return Array(allEvents[startIndex..<endIndex])
    }
    
    public func likeEvent(_ eventId: UUID) async throws {
        // Simule l'envoi d'un like au backend
        try await Task.sleep(nanoseconds: 200_000_000) // 0.2 secondes
        print("✅ Event \(eventId) liked successfully")
    }
    
    public func passEvent(_ eventId: UUID) async throws {
        // Simule l'envoi d'un pass au backend
        try await Task.sleep(nanoseconds: 200_000_000) // 0.2 secondes
        print("❌ Event \(eventId) passed successfully")
    }
}

// MARK: - SwipeViewModel Extensions
public extension SwipeViewModel {
    
    /// Statistiques pour le debug/analytics
    var statistics: SwipeStatistics {
        SwipeStatistics(
            totalEvents: events.count,
            currentIndex: currentEventIndex,
            progress: progress,
            hasMoreEvents: hasMoreEvents,
            isLoading: isLoading
        )
    }
}

// MARK: - Swipe Statistics
public struct SwipeStatistics {
    public let totalEvents: Int
    public let currentIndex: Int
    public let progress: Double
    public let hasMoreEvents: Bool
    public let isLoading: Bool
    
    public var remainingEvents: Int {
        max(0, totalEvents - currentIndex)
    }
    
    public var completedEvents: Int {
        currentIndex
    }
}

// MARK: - Error Types
public enum SwipeError: LocalizedError {
    case noMoreEvents
    case networkError(String)
    case invalidEvent
    
    public var errorDescription: String? {
        switch self {
        case .noMoreEvents:
            return "Plus d'événements disponibles"
        case .networkError(let message):
            return "Erreur réseau: \(message)"
        case .invalidEvent:
            return "Événement invalide"
        }
    }
} } 
