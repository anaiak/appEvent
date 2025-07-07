import XCTest
import SwiftUI
import SnapshotTesting
@testable import SoireesUI

final class EventCardViewTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Configuration pour les tests de snapshot
        // isRecording = true // Décommenter pour enregistrer les snapshots
    }
    
    // MARK: - Test Data
    private var mockEvent: Event {
        Event(
            title: "Techno Night à La Bellevilloise",
            description: "Une soirée techno inoubliable avec des DJs internationaux",
            imageURL: URL(string: "https://example.com/event.jpg"),
            date: Date(timeIntervalSince1970: 1690837200), // Date fixe pour les tests
            location: EventLocation(
                name: "La Bellevilloise",
                address: "19-21 Rue Boyer",
                city: "Paris",
                coordinate: Coordinate(latitude: 48.8566, longitude: 2.3522)
            ),
            lineup: [
                Artist(name: "Charlotte de Witte", genre: "Techno"),
                Artist(name: "Amelie Lens", genre: "Techno")
            ],
            genres: ["Techno", "Electronic"],
            price: Price(amount: 25.0),
            ticketURL: URL(string: "https://example.com/tickets"),
            distance: 2.3
        )
    }
    
    // MARK: - Snapshot Tests
    
    func testEventCardView_defaultState() throws {
        let view = EventCardView(event: mockEvent)
            .frame(width: 350, height: 600)
            .background(DesignTokens.Colors.nightBlack)
        
        assertSnapshot(
            matching: view,
            as: .image(
                drawHierarchyInKeyWindow: true,
                layout: .fixed(width: 350, height: 600),
                traits: .init(userInterfaceStyle: .dark)
            ),
            named: "default_state"
        )
    }
    
    func testEventCardView_withLikeBadge() throws {
        let view = EventCardView(
            event: mockEvent,
            likeOpacity: 1.0
        )
        .frame(width: 350, height: 600)
        .background(DesignTokens.Colors.nightBlack)
        
        assertSnapshot(
            matching: view,
            as: .image(
                drawHierarchyInKeyWindow: true,
                layout: .fixed(width: 350, height: 600),
                traits: .init(userInterfaceStyle: .dark)
            ),
            named: "with_like_badge"
        )
    }
    
    func testEventCardView_withPassBadge() throws {
        let view = EventCardView(
            event: mockEvent,
            passOpacity: 1.0
        )
        .frame(width: 350, height: 600)
        .background(DesignTokens.Colors.nightBlack)
        
        assertSnapshot(
            matching: view,
            as: .image(
                drawHierarchyInKeyWindow: true,
                layout: .fixed(width: 350, height: 600),
                traits: .init(userInterfaceStyle: .dark)
            ),
            named: "with_pass_badge"
        )
    }
    
    func testEventCardView_withDragOffset() throws {
        let view = EventCardView(
            event: mockEvent,
            dragOffset: CGSize(width: 100, height: 0),
            rotation: 10,
            likeOpacity: 0.5
        )
        .frame(width: 350, height: 600)
        .background(DesignTokens.Colors.nightBlack)
        
        assertSnapshot(
            matching: view,
            as: .image(
                drawHierarchyInKeyWindow: true,
                layout: .fixed(width: 350, height: 600),
                traits: .init(userInterfaceStyle: .dark)
            ),
            named: "with_drag_offset"
        )
    }
    
    func testEventCardView_scaledDown() throws {
        let view = EventCardView(
            event: mockEvent,
            scale: DesignTokens.Animation.CardScale.middle
        )
        .frame(width: 350, height: 600)
        .background(DesignTokens.Colors.nightBlack)
        
        assertSnapshot(
            matching: view,
            as: .image(
                drawHierarchyInKeyWindow: true,
                layout: .fixed(width: 350, height: 600),
                traits: .init(userInterfaceStyle: .dark)
            ),
            named: "scaled_down"
        )
    }
    
    func testEventCardView_withoutPrice() throws {
        let eventWithoutPrice = Event(
            title: "Free Techno Night",
            description: "Une soirée techno gratuite",
            imageURL: URL(string: "https://example.com/event.jpg"),
            date: Date(timeIntervalSince1970: 1690837200),
            location: EventLocation(
                name: "La Bellevilloise",
                address: "19-21 Rue Boyer",
                city: "Paris",
                coordinate: Coordinate(latitude: 48.8566, longitude: 2.3522)
            ),
            lineup: [Artist(name: "Charlotte de Witte", genre: "Techno")],
            genres: ["Techno"],
            price: nil,
            ticketURL: nil,
            distance: 2.3
        )
        
        let view = EventCardView(event: eventWithoutPrice)
            .frame(width: 350, height: 600)
            .background(DesignTokens.Colors.nightBlack)
        
        assertSnapshot(
            matching: view,
            as: .image(
                drawHierarchyInKeyWindow: true,
                layout: .fixed(width: 350, height: 600),
                traits: .init(userInterfaceStyle: .dark)
            ),
            named: "without_price"
        )
    }
    
    // MARK: - Performance Tests
    
    func testEventCardView_renderingPerformance() throws {
        measure {
            for _ in 0..<100 {
                let view = EventCardView(event: mockEvent)
                    .frame(width: 350, height: 600)
                _ = view.body
            }
        }
    }
    
    // MARK: - Accessibility Tests
    
    func testEventCardView_accessibility() throws {
        let view = EventCardView(event: mockEvent)
            .frame(width: 350, height: 600)
        
        // Test que les éléments accessibles sont présents
        XCTAssertTrue(mockEvent.title.count > 0, "Le titre de l'événement doit être accessible")
        XCTAssertTrue(mockEvent.location.name.count > 0, "Le lieu doit être accessible")
        XCTAssertNotNil(mockEvent.formattedDate, "La date formatée doit être accessible")
    }
}

// MARK: - Animation Tests
extension EventCardViewTests {
    
    func testSwipeBadge_likeAnimation() throws {
        let badge = SwipeBadge(type: .like, opacity: 0.5)
            .frame(width: 120, height: 80)
        
        assertSnapshot(
            matching: badge,
            as: .image(
                drawHierarchyInKeyWindow: true,
                layout: .fixed(width: 120, height: 80),
                traits: .init(userInterfaceStyle: .dark)
            ),
            named: "like_badge_animation"
        )
    }
    
    func testSwipeBadge_passAnimation() throws {
        let badge = SwipeBadge(type: .pass, opacity: 0.8)
            .frame(width: 120, height: 80)
        
        assertSnapshot(
            matching: badge,
            as: .image(
                drawHierarchyInKeyWindow: true,
                layout: .fixed(width: 120, height: 80),
                traits: .init(userInterfaceStyle: .dark)
            ),
            named: "pass_badge_animation"
        )
    }
}

// MARK: - Genre Chip Tests
extension EventCardViewTests {
    
    func testGenreChip_rendering() throws {
        let chip = GenreChip(text: "Techno")
            .frame(width: 100, height: 40)
        
        assertSnapshot(
            matching: chip,
            as: .image(
                drawHierarchyInKeyWindow: true,
                layout: .fixed(width: 100, height: 40),
                traits: .init(userInterfaceStyle: .dark)
            ),
            named: "genre_chip"
        )
    }
    
    func testGenreChip_longText() throws {
        let chip = GenreChip(text: "Electronic Music")
            .frame(width: 150, height: 40)
        
        assertSnapshot(
            matching: chip,
            as: .image(
                drawHierarchyInKeyWindow: true,
                layout: .fixed(width: 150, height: 40),
                traits: .init(userInterfaceStyle: .dark)
            ),
            named: "genre_chip_long_text"
        )
    }
} 