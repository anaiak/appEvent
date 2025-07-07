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
    
    // MARK: - Computed Properties
    
    /// Événement actuellement affiché
    public var currentEvent: Event? {
        guard currentEventIndex < events.count else { return nil }
        return events[currentEventIndex]
    }
    
    /// Prochains événements dans le deck (maximum 3)
    public var upcomingEvents: [Event] {
        let startIndex = currentEventIndex + 1
        let endIndex = min(startIndex + 3, events.count)
        guard startIndex < events.count else { return [] }
        return Array(events[startIndex..<endIndex])
    }
    
    /// Progression à travers les événements (0.0 - 1.0)
    public var progress: Double {
        guard !events.isEmpty else { return 0.0 }
        return Double(currentEventIndex) / Double(events.count)
    }
    
    /// Indique s'il reste des événements à swiper
    public var hasEventsRemaining: Bool {
        currentEventIndex < events.count || hasMoreEvents
    }
    
    /// Événements restants à swiper
    public var remainingEventsCount: Int {
        max(0, events.count - currentEventIndex)
    }
    
    /// Indique si on peut revenir en arrière
    public var canUndo: Bool {
        currentEventIndex > 0
    }
    
    // MARK: - Initialization
    
    public init(eventService: EventServiceProtocol = EventService()) {
        self.eventService = eventService
        setupErrorHandling()
    }
    
    // MARK: - Public Methods
    
    /// Charge les événements initiaux
    public func loadEvents() async {
        await loadMoreEvents()
    }
    
    /// Charge plus d'événements si nécessaire (preloading)
    private func loadMoreEventsIfNeeded() async {
        // Charge plus d'événements quand il ne reste que 2 événements
        let remainingEvents = events.count - currentEventIndex
        if remainingEvents <= 2 && hasMoreEvents && !isLoading {
            await loadMoreEvents()
        }
    }
    
    /// Like un événement et passe au suivant
    public func likeCurrentEvent() async {
        guard let event = currentEvent else { return }
        
        // TODO: Implémenter la logique de like (sauvegarde, analytics, etc.)
        print("❤️ Liked event: \(event.title)")
        
        // Feedback haptique immédiat
        DesignTokens.Haptics.impact(.medium).impactOccurred()
        
        // Passe à l'événement suivant
        await moveToNextEvent()
    }
    
    /// Passe un événement et passe au suivant
    public func passCurrentEvent() async {
        guard let event = currentEvent else { return }
        
        // Feedback haptique plus léger
        DesignTokens.Haptics.impact(.light).impactOccurred()
        
        // Passe à l'événement suivant
        await moveToNextEvent()
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
            let newEvents = try await eventService.fetchNearbyEvents(location: nil, offset: offset)
            
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
} 
