import SwiftUI
import PlaygroundSupport

// Import du package SoireesUI
// (Vous devrez ajouter le package au playground)

// Vue de test pour le playground
struct PlaygroundView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("🎉 Soirées Swipe - Playground")
                .font(.title)
                .foregroundColor(.white)
            
            // Test EventCardView
            EventCardView(
                event: SoireesPreviews.mockEvent,
                likeOpacity: 0.5
            )
            .frame(width: 300, height: 500)
            .cornerRadius(20)
            
            Text("Swipez pour liker ! ❤️")
                .foregroundColor(.pink)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
    }
}

// Lancer la preview
PlaygroundPage.current.setLiveView(
    PlaygroundView()
        .preferredColorScheme(.dark)
) 