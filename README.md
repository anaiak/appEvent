# 🎉 Soirées Swipe - Interface iOS

Une interface mobile fluide et immersive pour la découverte d'événements locaux via un système de swipe-cards innovant.

## 📱 Vue d'ensemble

**Soirées Swipe** est une application iOS native construite avec SwiftUI qui permet aux utilisateurs de :

- ✨ Découvrir des événements locaux via un flux swipe-card intuitif
- ❤️ Liker ou passer des événements d'un simple geste
- 👥 Partager instantanément leurs coups de cœur dans des groupes d'amis
- 📅 Consulter les détails complets et planifier dans leur agenda
- 🎵 Personnaliser leurs préférences musicales et critères de recherche

## 🛠 Stack Technique

- **Langage** : Swift 5.10
- **UI Framework** : SwiftUI avec pattern MVVM
- **Animations** : SwiftUI Animation + InteractiveSpring
- **État** : ObservableObject + @State + Combine
- **Persistance** : AppStorage & CoreData
- **Réseau** : URLSession + async/await
- **CI/CD** : Xcode Cloud + Fastlane
- **Tests** : XCTest + SnapshotTesting

## 🎨 Design System

### Palette de couleurs
- **Night Black** (`#0B0B0E`) - Arrière-plan global (Dark-mode only)
- **Neon Pink** (`#FF2D95`) - Accent like & CTA
- **Neon Blue** (`#2DF9FF`) - Accent secondaire (groupes)
- **Pure White** (`#FFFFFF`) - Texte principal
- **Gray 600** (`#7A7A7D`) - Sous-titres / séparateurs

### Typographie
- **SF Pro Rounded**
- Title : Bold 28pt
- Heading : Semibold 22pt
- Body : Regular 17pt
- Caption : 15pt

### Espacements
Système basé sur des multiples de 4 : 4-8-12-16-24-32pt

## 🏗 Architecture

### Structure du projet
```
Sources/SoireesUI/
├── DesignSystem/
│   └── DesignTokens.swift
├── Models/
│   ├── Event.swift
│   └── Group.swift
├── ViewModels/
│   └── SwipeViewModel.swift
├── Services/
│   └── EventService.swift
├── Views/
│   ├── SwipeView.swift
│   ├── EventDetailView.swift
│   ├── ProfileView.swift
│   ├── GroupsView.swift
│   └── Components/
│       └── EventCardView.swift
└── Resources/
    └── Tokens.json
```

### Pattern MVVM
- **Views** : SwiftUI Views déclaratives
- **ViewModels** : ObservableObject conformes avec méthodes async
- **Models** : Structures de données Codable
- **Services** : Couche d'accès aux données avec protocoles

## 🎯 Fonctionnalités principales

### 1. Flux Swipe
- Stack de 3 cartes avec scales différentes (1.0, 0.97, 0.94)
- Animations spring avec `response: 0.35, dampingFraction: 0.7`
- Seuils configurables : 120pt pour swipe, 40pt pour badge
- Haptic feedback sur interactions

### 2. Cartes d'événements
- Images full-width avec dégradé overlay
- Informations : titre, date, lieu, distance, genres, prix
- Badges animés (Like/Pass) avec opacité dynamique
- Support des chips de genres avec scroll horizontal

### 3. Détail d'événement
- Header avec parallax sur scroll
- Sheet modal avec description Markdown
- Line-up avec grid 2 colonnes
- Carte de localisation intégrée
- Actions : "Ajouter au groupe" & "Billetterie"

### 4. Gestion des groupes
- Liste horizontale avec icônes de groupes
- Feed en grid 2 colonnes des événements likés
- Système d'invitation par QR Code / lien
- matchedGeometryEffect pour les animations fluides

### 5. Profil & Préférences
- Formulaire avec List(InsetGroupedListStyle)
- Genres musicaux (Toggle Pills)
- Rayon de recherche (Slider)
- Budget maximum (Stepper)
- Gestion compte avec ConfirmationDialog

## 🚀 Installation

### Prérequis
- Xcode 15.0+
- iOS 17.0+
- Swift 5.10+

### Via Swift Package Manager
```swift
dependencies: [
    .package(url: "https://github.com/votre-org/soirees-ui", from: "1.0.0")
]
```

### Utilisation de base
```swift
import SwiftUI
import SoireesUI

@main
struct SoireesApp: App {
    init() {
        SoireesUI.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            SoireesUI.makeRootView()
        }
    }
}
```

## 🧪 Tests

### Tests de snapshot
```bash
# Lancer les tests de snapshot
xcodebuild test -scheme SoireesUI -destination 'platform=iOS Simulator,name=iPhone 15 Pro'
```

### Tests de performance
- Cible FPS : > 60 sur iPhone 12
- Temps de rendu < 16ms par frame
- Time-to-first-like < 30s après installation

### Tests d'accessibilité
- Support Dynamic Type jusqu'à XXL
- VoiceOver avec labels descriptifs
- Contrast ratio >= 4.5:1
- Tests automatisés avec Accessibility Inspector

## 📊 KPI & Métriques

### Performance
- **FPS moyen** : > 55 durant le swipe (XCPerformance)
- **Rendu** : < 16ms par frame (Core Animation)
- **Mémoire** : < 100MB en utilisation normale

### UX
- **Time-to-first-like** : < 30s après installation
- **Taux d'erreurs VoiceOver** : 0% (Accessibility Inspector)
- **Animations fluides** : 60fps constant sur iPhone 12+

## 📚 Documentation

### Design Tokens
Consultez `Sources/SoireesUI/Resources/Tokens.json` pour les valeurs complètes du design system.

### Styleguide
Le styleguide complet est disponible dans la documentation générée automatiquement.

### Prototype interactif
Un prototype Swift Playgrounds démontrant les animations de swipe et la stack de cartes est inclus.

## 🛣 Roadmap

### Version 1.1
- [ ] Support multilingue 🇫🇷/🇬🇧
- [ ] Mode hors ligne avancé
- [ ] Notifications push personnalisées
- [ ] Widget iOS pour événements du jour

### Version 1.2
- [ ] Réalité augmentée pour la localisation
- [ ] Machine learning pour recommandations
- [ ] Social sharing amélioré
- [ ] Mode spectateur pour événements live

## 🤝 Contribution

### Prérequis de développement
- SwiftLint configuré
- Tests systématiques pour nouveaux composants
- Respect du design system
- Documentation des API publiques

### Process de contribution
1. Fork du repository
2. Créer une branche feature
3. Implémenter avec tests
4. Linter avec SwiftLint
5. Pull Request avec description détaillée

## 📄 Licence

MIT License - Voir [LICENSE](LICENSE) pour les détails.

## 👥 Équipe

- **Design** : Système conçu pour une expérience utilisateur optimale
- **Développement** : Architecture SwiftUI moderne et performante
- **QA** : Tests automatisés et métriques de performance

---

**Soirées Swipe** - Découvrez la nuit, swipez votre style ! 🌙✨ 