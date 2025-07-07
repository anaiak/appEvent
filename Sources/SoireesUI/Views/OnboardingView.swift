import SwiftUI
import CoreLocation

// MARK: - Onboarding View
// Flow d'onboarding avec 3 slides selon spec : PageTabViewStyle + permissions géolocalisation

public struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var showingLocationPermission = false
    @State private var hasCompletedOnboarding = false
    @StateObject private var locationManager = LocationManager()
    
    let onComplete: () -> Void
    
    private let slides = OnboardingSlide.allSlides
    
    public init(onComplete: @escaping () -> Void) {
        self.onComplete = onComplete
    }
    
    public var body: some View {
        ZStack {
            // Background global
            DesignTokens.Colors.nightBlack
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Skip button
                HStack {
                    Spacer()
                    Button("Passer") {
                        DesignTokens.Haptics.selection.selectionChanged()
                        completeOnboarding()
                    }
                    .font(DesignTokens.Typography.bodyFont)
                    .foregroundStyle(DesignTokens.Colors.gray600)
                    .padding(.horizontal, DesignTokens.Spacing.lg)
                    .padding(.top, DesignTokens.Spacing.md)
                }
                .opacity(currentPage < slides.count - 1 ? 1 : 0)
                .animation(DesignTokens.Animation.fadeInOut, value: currentPage)
                
                // Slides content
                TabView(selection: $currentPage) {
                    ForEach(Array(slides.enumerated()), id: \.offset) { index, slide in
                        OnboardingSlideView(
                            slide: slide,
                            isLastSlide: index == slides.count - 1,
                            onContinue: {
                                if index == slides.count - 1 {
                                    requestLocationPermission()
                                } else {
                                    withAnimation(DesignTokens.Animation.standardSpring) {
                                        currentPage = index + 1
                                    }
                                }
                            }
                        )
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                
                Spacer()
            }
        }
        .onAppear {
            setupPageControl()
        }
        .sheet(isPresented: $showingLocationPermission) {
            LocationPermissionView(
                locationManager: locationManager,
                onComplete: completeOnboarding
            )
        }
    }
    
    private func setupPageControl() {
        // Customise les indicateurs de page
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(DesignTokens.Colors.neonPink)
        UIPageControl.appearance().pageIndicatorTintColor = UIColor(DesignTokens.Colors.gray600)
    }
    
    private func requestLocationPermission() {
        DesignTokens.Haptics.medium.impactOccurred()
        showingLocationPermission = true
    }
    
    private func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        onComplete()
    }
}

// MARK: - Onboarding Slide View
private struct OnboardingSlideView: View {
    let slide: OnboardingSlide
    let isLastSlide: Bool
    let onContinue: () -> Void
    
    var body: some View {
        VStack(spacing: DesignTokens.Spacing.xl) {
            Spacer()
            
            // Illustration principale
            ZStack {
                // Effet de glow
                slide.illustration
                    .font(.system(size: 120))
                    .foregroundStyle(slide.accentColor)
                    .blur(radius: 20)
                    .opacity(0.6)
                
                // Icône principale
                slide.illustration
                    .font(.system(size: 120))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                slide.accentColor,
                                slide.accentColor.opacity(0.8)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            .scaleEffect(1.0)
            .animation(
                DesignTokens.Animation.springBounce.repeatForever(autoreverses: true),
                value: slide.id
            )
            
            Spacer()
            
            // Contenu textuel
            VStack(spacing: DesignTokens.Spacing.lg) {
                Text(slide.title)
                    .font(DesignTokens.Typography.largeTitleFont)
                    .foregroundStyle(DesignTokens.Colors.pureWhite)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                
                Text(slide.description)
                    .font(DesignTokens.Typography.bodyFont)
                    .foregroundStyle(DesignTokens.Colors.gray600)
                    .multilineTextAlignment(.center)
                    .lineSpacing(6)
                    .padding(.horizontal, DesignTokens.Spacing.xl)
                
                // Features bullets
                VStack(spacing: DesignTokens.Spacing.md) {
                    ForEach(slide.features, id: \.self) { feature in
                        FeatureBullet(text: feature, accentColor: slide.accentColor)
                    }
                }
                .padding(.top, DesignTokens.Spacing.md)
            }
            
            Spacer()
            
            // Bouton d'action
            Button(action: {
                DesignTokens.Haptics.light.impactOccurred()
                onContinue()
            }) {
                HStack {
                    Text(isLastSlide ? "Commencer" : "Continuer")
                        .font(DesignTokens.Typography.headingFont)
                    
                    if !isLastSlide {
                        Image(systemName: "arrow.right")
                            .font(DesignTokens.Typography.headingFont)
                    }
                }
                .foregroundStyle(DesignTokens.Colors.pureWhite)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, DesignTokens.Spacing.lg)
                .padding(.vertical, DesignTokens.Spacing.md)
                .background(
                    LinearGradient(
                        colors: [
                            slide.accentColor,
                            slide.accentColor.opacity(0.8)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: DesignTokens.Radius.button))
                .shadow(
                    color: slide.accentColor.opacity(0.4),
                    radius: 12,
                    x: 0,
                    y: 6
                )
            }
            .padding(.horizontal, DesignTokens.Spacing.xl)
            .padding(.bottom, DesignTokens.Spacing.xxl)
        }
        .padding(DesignTokens.Spacing.lg)
    }
}

// MARK: - Feature Bullet
private struct FeatureBullet: View {
    let text: String
    let accentColor: Color
    
    var body: some View {
        HStack(spacing: DesignTokens.Spacing.sm) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 20))
                .foregroundStyle(accentColor)
            
            Text(text)
                .font(DesignTokens.Typography.bodyFont)
                .foregroundStyle(DesignTokens.Colors.pureWhite)
            
            Spacer()
        }
        .padding(.horizontal, DesignTokens.Spacing.lg)
    }
}

// MARK: - Location Permission View
private struct LocationPermissionView: View {
    @ObservedObject var locationManager: LocationManager
    @Environment(\.dismiss) private var dismiss
    let onComplete: () -> Void
    
    var body: some View {
        NavigationView {
            VStack(spacing: DesignTokens.Spacing.xl) {
                Spacer()
                
                // Icône
                ZStack {
                    Image(systemName: "location.circle.fill")
                        .font(.system(size: 100))
                        .foregroundStyle(DesignTokens.Colors.neonBlue)
                        .blur(radius: 15)
                        .opacity(0.6)
                    
                    Image(systemName: "location.circle.fill")
                        .font(.system(size: 100))
                        .foregroundStyle(DesignTokens.Colors.neonBlue)
                }
                
                // Contenu
                VStack(spacing: DesignTokens.Spacing.lg) {
                    Text("Localisation")
                        .font(DesignTokens.Typography.titleFont)
                        .foregroundStyle(DesignTokens.Colors.pureWhite)
                    
                    Text("Nous avons besoin de votre position pour vous recommander les meilleures soirées près de chez vous.")
                        .font(DesignTokens.Typography.bodyFont)
                        .foregroundStyle(DesignTokens.Colors.gray600)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .padding(.horizontal, DesignTokens.Spacing.lg)
                    
                    VStack(spacing: DesignTokens.Spacing.md) {
                        FeatureBullet(
                            text: "Événements recommandés selon votre position",
                            accentColor: DesignTokens.Colors.neonBlue
                        )
                        FeatureBullet(
                            text: "Calcul automatique des distances",
                            accentColor: DesignTokens.Colors.neonBlue
                        )
                        FeatureBullet(
                            text: "Notifications pour les événements locaux",
                            accentColor: DesignTokens.Colors.neonBlue
                        )
                    }
                }
                
                Spacer()
                
                // Boutons
                VStack(spacing: DesignTokens.Spacing.md) {
                    Button(action: {
                        locationManager.requestPermission()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            completePermissionFlow()
                        }
                    }) {
                        Text("Autoriser la localisation")
                            .font(DesignTokens.Typography.headingFont)
                            .foregroundStyle(DesignTokens.Colors.pureWhite)
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, DesignTokens.Spacing.lg)
                            .padding(.vertical, DesignTokens.Spacing.md)
                            .background(DesignTokens.Colors.neonBlue)
                            .clipShape(RoundedRectangle(cornerRadius: DesignTokens.Radius.button))
                    }
                    
                    Button(action: {
                        completePermissionFlow()
                    }) {
                        Text("Continuer sans localisation")
                            .font(DesignTokens.Typography.bodyFont)
                            .foregroundStyle(DesignTokens.Colors.gray600)
                    }
                }
                .padding(.horizontal, DesignTokens.Spacing.xl)
                .padding(.bottom, DesignTokens.Spacing.xxl)
            }
            .padding(DesignTokens.Spacing.lg)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(DesignTokens.Colors.nightBlack)
            .navigationTitle("Permissions")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
        }
    }
    
    private func completePermissionFlow() {
        DesignTokens.Haptics.success.notificationOccurred(.success)
        dismiss()
        onComplete()
    }
}

// MARK: - Onboarding Slide Model
private struct OnboardingSlide: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let features: [String]
    let illustration: Image
    let accentColor: Color
    
    static let allSlides: [OnboardingSlide] = [
        OnboardingSlide(
            title: "Découvrez les meilleures soirées",
            description: "Explorez les événements les plus hot près de chez vous. De la techno underground aux festivals électro, trouvez votre prochaine expérience musicale inoubliable.",
            features: [
                "Événements personnalisés selon vos goûts",
                "Filtres par genre musical et distance",
                "Recommandations intelligentes"
            ],
            illustration: Image(systemName: "sparkles"),
            accentColor: DesignTokens.Colors.neonPink
        ),
        
        OnboardingSlide(
            title: "Swipez pour choisir",
            description: "Un simple geste pour dire oui ou non ! Swipez à droite pour liker, à gauche pour passer. Notre algorithme apprend de vos préférences pour vous proposer des événements toujours plus pertinents.",
            features: [
                "Interface intuitive et rapide",
                "Apprentissage de vos préférences",
                "Gestes naturels et fluides"
            ],
            illustration: Image(systemName: "hand.draw"),
            accentColor: DesignTokens.Colors.neonBlue
        ),
        
        OnboardingSlide(
            title: "Partagez avec vos amis",
            description: "Créez des groupes avec vos amis, partagez vos coups de cœur et planifiez vos sorties ensemble. La fête est toujours meilleure quand elle est partagée !",
            features: [
                "Groupes d'amis synchronisés",
                "Recommandations partagées",
                "Planification collaborative"
            ],
            illustration: Image(systemName: "person.3.fill"),
            accentColor: DesignTokens.Colors.successColor
        )
    ]
}

// MARK: - Location Manager
public class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published public var currentLocation: CLLocation?
    @Published public var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    private let locationManager = CLLocationManager()
    
    public override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        authorizationStatus = locationManager.authorizationStatus
    }
    
    public func requestPermission() {
        switch authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            // Redirection vers les paramètres
            if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsUrl)
            }
        case .authorizedWhenInUse, .authorizedAlways:
            startLocationUpdates()
        @unknown default:
            break
        }
    }
    
    private func startLocationUpdates() {
        guard authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways else {
            return
        }
        locationManager.startUpdatingLocation()
    }
    
    // MARK: - CLLocationManagerDelegate
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
        locationManager.stopUpdatingLocation()
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatus = status
        
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            startLocationUpdates()
        case .denied, .restricted:
            currentLocation = nil
        default:
            break
        }
    }
}

// MARK: - Preview
#Preview("Onboarding") {
    OnboardingView(onComplete: {
        print("Onboarding completed!")
    })
    .preferredColorScheme(.dark)
}

#Preview("Single Slide") {
    OnboardingSlideView(
        slide: OnboardingSlide.allSlides[0],
        isLastSlide: false,
        onContinue: {}
    )
    .background(DesignTokens.Colors.nightBlack)
    .preferredColorScheme(.dark)
}

#Preview("Location Permission") {
    LocationPermissionView(
        locationManager: LocationManager(),
        onComplete: {}
    )
    .preferredColorScheme(.dark)
} 