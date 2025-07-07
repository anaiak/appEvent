import Foundation
import CoreLocation

// MARK: - Event Model
public struct Event: Identifiable, Codable, Hashable {
    public let id: UUID
    public let title: String
    public let description: String
    public let imageURL: URL?
    public let date: Date
    public let location: EventLocation
    public let lineup: [Artist]
    public let genres: [String]
    public let price: Price?
    public let ticketURL: URL?
    public let distance: Double? // Distance en kilomètres
    
    public init(
        id: UUID = UUID(),
        title: String,
        description: String,
        imageURL: URL?,
        date: Date,
        location: EventLocation,
        lineup: [Artist],
        genres: [String],
        price: Price?,
        ticketURL: URL?,
        distance: Double? = nil
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.imageURL = imageURL
        self.date = date
        self.location = location
        self.lineup = lineup
        self.genres = genres
        self.price = price
        self.ticketURL = ticketURL
        self.distance = distance
    }
}

// MARK: - Event Location
public struct EventLocation: Codable, Hashable {
    public let name: String
    public let address: String
    public let city: String
    public let coordinate: Coordinate
    
    public init(name: String, address: String, city: String, coordinate: Coordinate) {
        self.name = name
        self.address = address
        self.city = city
        self.coordinate = coordinate
    }
}

// MARK: - Coordinate
public struct Coordinate: Codable, Hashable {
    public let latitude: Double
    public let longitude: Double
    
    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    public var clLocationCoordinate2D: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

// MARK: - Artist
public struct Artist: Identifiable, Codable, Hashable {
    public let id: UUID
    public let name: String
    public let genre: String?
    public let imageURL: URL?
    
    public init(id: UUID = UUID(), name: String, genre: String? = nil, imageURL: URL? = nil) {
        self.id = id
        self.name = name
        self.genre = genre
        self.imageURL = imageURL
    }
}

// MARK: - Price
public struct Price: Codable, Hashable {
    public let amount: Double
    public let currency: String
    
    public init(amount: Double, currency: String = "EUR") {
        self.amount = amount
        self.currency = currency
    }
    
    public var formatted: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currency
        return formatter.string(from: NSNumber(value: amount)) ?? "\(amount) \(currency)"
    }
}

// MARK: - Event Extensions
extension Event {
    public var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale.current
        return formatter.string(from: date)
    }
    
    public var formattedDistance: String? {
        guard let distance = distance else { return nil }
        return String(format: "%.1f km", distance)
    }
    
    public var isToday: Bool {
        Calendar.current.isDateInToday(date)
    }
    
    public var isUpcoming: Bool {
        date > Date()
    }
} 