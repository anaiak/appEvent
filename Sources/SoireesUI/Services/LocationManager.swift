import Foundation
import CoreLocation
import Combine

// MARK: - Location Manager
// Service centralisé pour la gestion de la géolocalisation

public class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published public var currentLocation: CLLocation?
    @Published public var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published public var isLocationAvailable: Bool = false
    
    private let locationManager = CLLocationManager()
    
    public override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        authorizationStatus = locationManager.authorizationStatus
        updateLocationAvailability()
    }
    
    /// Demande l'autorisation de géolocalisation
    public func requestPermission() {
        switch authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            // Redirection vers les paramètres système
            openSettingsApp()
        case .authorizedWhenInUse, .authorizedAlways:
            startLocationUpdates()
        @unknown default:
            break
        }
    }
    
    /// Lance les mises à jour de localisation
    public func startLocationUpdates() {
        guard authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways else {
            return
        }
        locationManager.startUpdatingLocation()
    }
    
    /// Arrête les mises à jour de localisation
    public func stopLocationUpdates() {
        locationManager.stopUpdatingLocation()
    }
    
    /// Obtient la position actuelle une seule fois
    public func getCurrentLocation() {
        guard authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways else {
            requestPermission()
            return
        }
        locationManager.requestLocation()
    }
    
    // MARK: - Private Methods
    
    private func updateLocationAvailability() {
        isLocationAvailable = authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways
    }
    
    private func openSettingsApp() {
        if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
            DispatchQueue.main.async {
                UIApplication.shared.open(settingsUrl)
            }
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
        // Arrête automatiquement les mises à jour après avoir obtenu une position
        locationManager.stopUpdatingLocation()
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatus = status
        updateLocationAvailability()
        
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            startLocationUpdates()
        case .denied, .restricted:
            currentLocation = nil
        default:
            break
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Erreur de géolocalisation: \(error.localizedDescription)")
    }
}

// MARK: - LocationManager Extensions
public extension LocationManager {
    
    /// État de permission lisible
    var permissionStatusText: String {
        switch authorizationStatus {
        case .notDetermined:
            return "Permission non déterminée"
        case .denied:
            return "Permission refusée"
        case .restricted:
            return "Permission restreinte"
        case .authorizedWhenInUse:
            return "Autorisé en utilisation"
        case .authorizedAlways:
            return "Toujours autorisé"
        @unknown default:
            return "État inconnu"
        }
    }
    
    /// Distance en kilomètres vers une coordonnée
    func distance(to coordinate: CLLocationCoordinate2D) -> Double? {
        guard let currentLocation = currentLocation else { return nil }
        
        let targetLocation = CLLocation(
            latitude: coordinate.latitude,
            longitude: coordinate.longitude
        )
        
        return currentLocation.distance(from: targetLocation) / 1000.0 // Conversion en km
    }
} 