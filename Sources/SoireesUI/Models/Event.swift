import Foundation
import SwiftUI
import CoreLocation

// MARK: - Event Model
// Modèle principal pour les événements/soirées

public struct Event: Identifiable, Codable, Hashable {
    public let id: UUID
    public let title: String
    public let description: String
    public let imageURL: String
    public let date: Date
    public let endDate: Date?
    public let venue: Venue
    public let organizer: Organizer
    public let musicGenres: [MusicGenre]
    public let ticketInfo: TicketInfo
    public let lineup: [Artist]
    public let tags: [String]
    public let ageRestriction: AgeRestriction
    public let capacity: Int?
    public let attendeeCount: Int
    public let isLiked: Bool
    public let isPassed: Bool
    public let createdAt: Date
    public let updatedAt: Date
    
    // Propriétés calculées
    public var distance: Double? {
        // Distance sera calculée par rapport à la position de l'utilisateur
        venue.distance
    }
    
    public var isToday: Bool {
        Calendar.current.isDateInToday(date)
    }
    
    public var isTomorrow: Bool {
        Calendar.current.isDateInTomorrow(date)
    }
    
    public var isThisWeek: Bool {
        let calendar = Calendar.current
        return calendar.isDate(date, equalTo: Date(), toGranularity: .weekOfYear)
    }
    
    public var formattedDate: String {
        let formatter = DateFormatter()
        
        if isToday {
            return "Aujourd'hui"
        } else if isTomorrow {
            return "Demain"
        } else if isThisWeek {
            formatter.dateFormat = "EEEE"
            return formatter.string(from: date).capitalized
        } else {
            formatter.dateFormat = "dd MMM"
            return formatter.string(from: date)
        }
    }
    
    public var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    public var formattedDistance: String {
        guard let distance = distance else { return "" }
        
        if distance < 1.0 {
            return "\(Int(distance * 1000))m"
        } else {
            return String(format: "%.1fkm", distance)
        }
    }
    
    public var priceRange: String {
        if ticketInfo.isFree {
            return "Gratuit"
        } else if let minPrice = ticketInfo.minPrice, let maxPrice = ticketInfo.maxPrice {
            if minPrice == maxPrice {
                return "\(Int(minPrice))€"
            } else {
                return "\(Int(minPrice))-\(Int(maxPrice))€"
            }
        } else if let price = ticketInfo.minPrice ?? ticketInfo.maxPrice {
            return "À partir de \(Int(price))€"
        }
        return "Prix non disponible"
    }
    
    public init(
        id: UUID = UUID(),
        title: String,
        description: String,
        imageURL: String,
        date: Date,
        endDate: Date? = nil,
        venue: Venue,
        organizer: Organizer,
        musicGenres: [MusicGenre] = [],
        ticketInfo: TicketInfo,
        lineup: [Artist] = [],
        tags: [String] = [],
        ageRestriction: AgeRestriction = .eighteenPlus,
        capacity: Int? = nil,
        attendeeCount: Int = 0,
        isLiked: Bool = false,
        isPassed: Bool = false,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.imageURL = imageURL
        self.date = date
        self.endDate = endDate
        self.venue = venue
        self.organizer = organizer
        self.musicGenres = musicGenres
        self.ticketInfo = ticketInfo
        self.lineup = lineup
        self.tags = tags
        self.ageRestriction = ageRestriction
        self.capacity = capacity
        self.attendeeCount = attendeeCount
        self.isLiked = isLiked
        self.isPassed = isPassed
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

// MARK: - Venue Model
public struct Venue: Identifiable, Codable, Hashable {
    public let id: UUID
    public let name: String
    public let address: String
    public let city: String
    public let postalCode: String
    public let country: String
    public let coordinate: Coordinate
    public let capacity: Int?
    public let website: String?
    public let phone: String?
    public var distance: Double? // Calculée dynamiquement
    
    public var fullAddress: String {
        "\(address), \(postalCode) \(city)"
    }
    
    public init(
        id: UUID = UUID(),
        name: String,
        address: String,
        city: String,
        postalCode: String,
        country: String = "France",
        coordinate: Coordinate,
        capacity: Int? = nil,
        website: String? = nil,
        phone: String? = nil,
        distance: Double? = nil
    ) {
        self.id = id
        self.name = name
        self.address = address
        self.city = city
        self.postalCode = postalCode
        self.country = country
        self.coordinate = coordinate
        self.capacity = capacity
        self.website = website
        self.phone = phone
        self.distance = distance
    }
}

// MARK: - Coordinate Model
public struct Coordinate: Codable, Hashable {
    public let latitude: Double
    public let longitude: Double
    
    public var clLocationCoordinate2D: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

// MARK: - Organizer Model
public struct Organizer: Identifiable, Codable, Hashable {
    public let id: UUID
    public let name: String
    public let bio: String?
    public let imageURL: String?
    public let website: String?
    public let socialMedia: SocialMedia?
    public let verified: Bool
    
    public init(
        id: UUID = UUID(),
        name: String,
        bio: String? = nil,
        imageURL: String? = nil,
        website: String? = nil,
        socialMedia: SocialMedia? = nil,
        verified: Bool = false
    ) {
        self.id = id
        self.name = name
        self.bio = bio
        self.imageURL = imageURL
        self.website = website
        self.socialMedia = socialMedia
        self.verified = verified
    }
}

// MARK: - Social Media Model
public struct SocialMedia: Codable, Hashable {
    public let instagram: String?
    public let facebook: String?
    public let twitter: String?
    public let tiktok: String?
    
    public init(
        instagram: String? = nil,
        facebook: String? = nil,
        twitter: String? = nil,
        tiktok: String? = nil
    ) {
        self.instagram = instagram
        self.facebook = facebook
        self.twitter = twitter
        self.tiktok = tiktok
    }
}

// MARK: - Music Genre Enum
public enum MusicGenre: String, CaseIterable, Codable, Hashable {
    case techno = "Techno"
    case house = "House"
    case electro = "Electro"
    case minimal = "Minimal"
    case trance = "Trance"
    case dubstep = "Dubstep"
    case drum_and_bass = "Drum & Bass"
    case ambient = "Ambient"
    case progressive = "Progressive"
    case deepHouse = "Deep House"
    case techHouse = "Tech House"
    case hardTechno = "Hard Techno"
    case acidTechno = "Acid Techno"
    case industrial = "Industrial"
    case breakbeat = "Breakbeat"
    case garage = "Garage"
    case future = "Future"
    case experimental = "Experimental"
    
    public var emoji: String {
        switch self {
        case .techno, .hardTechno, .acidTechno: return "⚡"
        case .house, .deepHouse, .techHouse: return "🏠"
        case .electro: return "🔊"
        case .minimal: return "⚪"
        case .trance: return "🌀"
        case .dubstep: return "💥"
        case .drum_and_bass: return "🥁"
        case .ambient: return "☁️"
        case .progressive: return "🌊"
        case .industrial: return "⚙️"
        case .breakbeat: return "💿"
        case .garage: return "🚗"
        case .future: return "🚀"
        case .experimental: return "🧪"
        }
    }
}

// MARK: - Artist Model
public struct Artist: Identifiable, Codable, Hashable {
    public let id: UUID
    public let name: String
    public let bio: String?
    public let imageURL: String?
    public let genres: [MusicGenre]
    public let isHeadliner: Bool
    public let socialMedia: SocialMedia?
    
    public init(
        id: UUID = UUID(),
        name: String,
        bio: String? = nil,
        imageURL: String? = nil,
        genres: [MusicGenre] = [],
        isHeadliner: Bool = false,
        socialMedia: SocialMedia? = nil
    ) {
        self.id = id
        self.name = name
        self.bio = bio
        self.imageURL = imageURL
        self.genres = genres
        self.isHeadliner = isHeadliner
        self.socialMedia = socialMedia
    }
}

// MARK: - Ticket Info Model
public struct TicketInfo: Codable, Hashable {
    public let isFree: Bool
    public let minPrice: Double?
    public let maxPrice: Double?
    public let currency: String
    public let ticketURL: String?
    public let salesEndDate: Date?
    public let availability: TicketAvailability
    
    public init(
        isFree: Bool = false,
        minPrice: Double? = nil,
        maxPrice: Double? = nil,
        currency: String = "EUR",
        ticketURL: String? = nil,
        salesEndDate: Date? = nil,
        availability: TicketAvailability = .available
    ) {
        self.isFree = isFree
        self.minPrice = minPrice
        self.maxPrice = maxPrice
        self.currency = currency
        self.ticketURL = ticketURL
        self.salesEndDate = salesEndDate
        self.availability = availability
    }
}

// MARK: - Ticket Availability Enum
public enum TicketAvailability: String, Codable, Hashable {
    case available = "available"
    case limitedAvailability = "limited"
    case soldOut = "sold_out"
    case comingSoon = "coming_soon"
    case salesEnded = "sales_ended"
    
    public var displayText: String {
        switch self {
        case .available: return "Disponible"
        case .limitedAvailability: return "Places limitées"
        case .soldOut: return "Complet"
        case .comingSoon: return "Bientôt disponible"
        case .salesEnded: return "Ventes terminées"
        }
    }
    
    public var color: Color {
        switch self {
        case .available: return DesignTokens.Colors.successColor
        case .limitedAvailability: return DesignTokens.Colors.warningColor
        case .soldOut: return DesignTokens.Colors.errorColor
        case .comingSoon: return DesignTokens.Colors.neonBlue
        case .salesEnded: return DesignTokens.Colors.gray600
        }
    }
}

// MARK: - Age Restriction Enum
public enum AgeRestriction: String, Codable, Hashable {
    case allAges = "all_ages"
    case sixteenPlus = "16_plus"
    case eighteenPlus = "18_plus"
    case twentyOnePlus = "21_plus"
    
    public var displayText: String {
        switch self {
        case .allAges: return "Tout âge"
        case .sixteenPlus: return "16+"
        case .eighteenPlus: return "18+"
        case .twentyOnePlus: return "21+"
        }
    }
    
    public var emoji: String {
        switch self {
        case .allAges: return "👶"
        case .sixteenPlus: return "🧑"
        case .eighteenPlus: return "🔞"
        case .twentyOnePlus: return "🍺"
        }
    }
}

// MARK: - Computed Properties
extension Event {
    /// Date formatée en français
    public var formattedDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "fr_FR")
        formatter.dateFormat = "EEEE d MMMM yyyy"
        return formatter.string(from: date).capitalized
    }
    
    /// Heure formatée
    public var formattedTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    /// Distance formatée
    public var formattedDistance: String {
        guard let distance = venue.distance else { return "" }
        
        if distance < 1.0 {
            return String(format: "%.0f m", distance * 1000)
        } else {
            return String(format: "%.1f km", distance)
        }
    }
    
    /// Vérifie si l'événement est aujourd'hui
    public var isToday: Bool {
        Calendar.current.isDateInToday(date)
    }
    
    /// Vérifie si l'événement est demain
    public var isTomorrow: Bool {
        Calendar.current.isDateInTomorrow(date)
    }
    
    /// Range de prix formaté
    public var priceRange: String {
        if ticketInfo.isFree {
            return "Gratuit"
        }
        
        guard let minPrice = ticketInfo.minPrice else {
            return "Prix non communiqué"
        }
        
        if let maxPrice = ticketInfo.maxPrice, maxPrice != minPrice {
            return "\(Int(minPrice))€ - \(Int(maxPrice))€"
        } else {
            return "\(Int(minPrice))€"
        }
    }
}

// MARK: - Extensions for Mock Data
public extension Event {
    static var mockEvents: [Event] {
        [
            Event(
                title: "Techno Night at La Bellevilloise",
                description: "Une soirée techno inoubliable avec les meilleurs DJs de la scène parisienne. Venez danser jusqu'au bout de la nuit dans cette ambiance unique.",
                imageURL: "https://images.unsplash.com/photo-1571266028243-d220c5e0fce4?w=800",
                date: Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date(),
                venue: Venue(
                    name: "La Bellevilloise",
                    address: "19-21 Rue Boyer",
                    city: "Paris",
                    postalCode: "75020",
                    coordinate: Coordinate(latitude: 48.8738, longitude: 2.3910),
                    distance: 2.3
                ),
                organizer: Organizer(
                    name: "Concrete Events",
                    verified: true
                ),
                musicGenres: [.techno, .minimal],
                ticketInfo: TicketInfo(
                    minPrice: 15,
                    maxPrice: 25,
                    ticketURL: "https://example.com/tickets"
                ),
                lineup: [
                    Artist(name: "Charlotte de Witte", isHeadliner: true),
                    Artist(name: "Amelie Lens"),
                    Artist(name: "I Hate Models")
                ],
                ageRestriction: .eighteenPlus,
                attendeeCount: 450
            ),
            
            Event(
                title: "House Music Festival",
                description: "Le plus grand festival de house music de France revient pour une édition exceptionnelle.",
                imageURL: "https://images.unsplash.com/photo-1549824928-47168bb8aa00?w=800",
                date: Calendar.current.date(byAdding: .day, value: 3, to: Date()) ?? Date(),
                venue: Venue(
                    name: "Parc de la Villette",
                    address: "211 Avenue Jean Jaurès",
                    city: "Paris",
                    postalCode: "75019",
                    coordinate: Coordinate(latitude: 48.8938, longitude: 2.3905),
                    distance: 5.7
                ),
                organizer: Organizer(
                    name: "Festival Organization",
                    verified: true
                ),
                musicGenres: [.house, .deepHouse, .techHouse],
                ticketInfo: TicketInfo(
                    minPrice: 35,
                    maxPrice: 55
                ),
                lineup: [
                    Artist(name: "Dixon", isHeadliner: true),
                    Artist(name: "Tale Of Us"),
                    Artist(name: "Mind Against")
                ],
                ageRestriction: .eighteenPlus,
                attendeeCount: 1200
            ),
            
            Event(
                title: "Underground Rave",
                description: "Soirée underground dans un lieu secret. Ambiance garantie pour les vrais amateurs.",
                imageURL: "https://images.unsplash.com/photo-1516450360452-9312f5e86fc7?w=800",
                date: Calendar.current.date(byAdding: .hour, value: 6, to: Date()) ?? Date(),
                venue: Venue(
                    name: "Lieu Secret",
                    address: "Adresse communiquée 2h avant",
                    city: "Paris",
                    postalCode: "75018",
                    coordinate: Coordinate(latitude: 48.8846, longitude: 2.3452),
                    distance: 0.8
                ),
                organizer: Organizer(
                    name: "Underground Collective"
                ),
                musicGenres: [.hardTechno, .industrial],
                ticketInfo: TicketInfo(
                    minPrice: 10,
                    maxPrice: 15,
                    availability: .limitedAvailability
                ),
                ageRestriction: .eighteenPlus,
                attendeeCount: 150
            )
        ]
    }
} 