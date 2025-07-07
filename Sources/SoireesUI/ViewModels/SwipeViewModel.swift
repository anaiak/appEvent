import SwiftUI
import Combine
import CoreLocation

// MARK: - Swipe View Model
@MainActor
public class SwipeViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published public var events: [Event] = []
    @Published public var currentIndex: Int = 0
    @Published public var likedEvents: Set<UUID> = []
    @Published public var passedEvents: Set<UUID> = []
    @Published public var isLoading: Bool = false
    @Published public var error: SwipeError?
    
    // MARK: - Swipe State
    @Published public var dragOffset: CGSize = .zero
    @Published public var rotation: Double = 0
    @Published public var likeOpacity: Double = 0
    @Published public var passOpacity: Double = 0
    
    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    private let eventService: EventServiceProtocol
    private let locationManager: LocationManager
    
    // MARK: - Initialization
    public init(
        eventService: EventServiceProtocol = EventService(),
        locationManager: LocationManager = LocationManager()
    ) {
        self.eventService = eventService
        self.locationManager = locationManager
        setupObservers()
    }
    
    // MARK: - Public Methods
    public func loadEvents() async {
        isLoading = true
        error = nil
        
        do {
            let newEvents = try await eventService.fetchNearbyEvents(
                location: locationManager.currentLocation?.coordinate
            )
            
            await MainActor.run {
                self.events = newEvents
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.error = SwipeError.networkError(error.localizedDescription)
                self.isLoading = false
            }
        }
    }
    
    public func handleSwipe(direction: SwipeDirection) {
        guard currentIndex < events.count else { return }
        
        let currentEvent = events[currentIndex]
        
        withAnimation(DesignTokens.Animation.spring) {
            switch direction {
            case .like:
                likedEvents.insert(currentEvent.id)
                dragOffset = CGSize(width: 500, height: 0)
                rotation = 15
                
            case .pass:
                passedEvents.insert(currentEvent.id)
                dragOffset = CGSize(width: -500, height: 0)
                rotation = -15
            }
        }
        
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        
        // Avancer à la carte suivante après un délai
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.nextCard()
        }
    }
    
    public func updateDragOffset(_ offset: CGSize) {
        dragOffset = offset
        rotation = Double(offset.width / 10)
        
        // Calculer l'opacité des badges
        let threshold = DesignTokens.Animation.likeThreshold
        
        if offset.width > 0 {
            likeOpacity = min(1.0, Double(offset.width / threshold))
            passOpacity = 0
        } else {
            passOpacity = min(1.0, Double(abs(offset.width) / threshold))
            likeOpacity = 0
        }
    }
    
    public func resetCardPosition() {
        withAnimation(DesignTokens.Animation.spring) {
            dragOffset = .zero
            rotation = 0
            likeOpacity = 0
            passOpacity = 0
        }
    }
    
    public func shouldTriggerSwipe(for offset: CGSize) -> SwipeDirection? {
        let threshold = DesignTokens.Animation.swipeThreshold
        
        if offset.width > threshold {
            return .like
        } else if offset.width < -threshold {
            return .pass
        }
        
        return nil
    }
    
    // MARK: - Private Methods
    private func setupObservers() {
        // Observer les changements de localisation
        locationManager.$currentLocation
            .compactMap { $0 }
            .sink { [weak self] _ in
                Task {
                    await self?.loadEvents()
                }
            }
            .store(in: &cancellables)
    }
    
    private func nextCard() {
        dragOffset = .zero
        rotation = 0
        likeOpacity = 0
        passOpacity = 0
        
        currentIndex += 1
        
        // Précharger plus d'événements si nécessaire
        if currentIndex >= events.count - 2 {
            Task {
                await loadMoreEvents()
            }
        }
    }
    
    private func loadMoreEvents() async {
        do {
            let moreEvents = try await eventService.fetchNearbyEvents(
                location: locationManager.currentLocation?.coordinate,
                offset: events.count
            )
            
            await MainActor.run {
                self.events.append(contentsOf: moreEvents)
            }
        } catch {
            // Gérer l'erreur silencieusement pour le préchargement
            print("Erreur lors du préchargement: \(error)")
        }
    }
}

// MARK: - Computed Properties
extension SwipeViewModel {
    public var currentEvent: Event? {
        guard currentIndex < events.count else { return nil }
        return events[currentIndex]
    }
    
    public var nextEvent: Event? {
        let nextIndex = currentIndex + 1
        guard nextIndex < events.count else { return nil }
        return events[nextIndex]
    }
    
    public var thirdEvent: Event? {
        let thirdIndex = currentIndex + 2
        guard thirdIndex < events.count else { return nil }
        return events[thirdIndex]
    }
    
    public var hasMoreEvents: Bool {
        currentIndex < events.count
    }
}

// MARK: - Swipe Direction
public enum SwipeDirection {
    case like
    case pass
}

// MARK: - Swipe Error
public enum SwipeError: LocalizedError {
    case networkError(String)
    case locationUnavailable
    case noEventsFound
    
    public var errorDescription: String? {
        switch self {
        case .networkError(let message):
            return "Erreur réseau: \(message)"
        case .locationUnavailable:
            return "Localisation non disponible"
        case .noEventsFound:
            return "Aucun événement trouvé"
        }
    }
} 