
import SwiftUI

struct StartingPage: View {
    @State private var navigateToOpeningScene = false
    var body: some View {
        
        ZStack {
            GifWebView(gifName: "StarryBackground2")
                 // .ignoresSafeArea()
                   
            Button(action: {
                navigateToOpeningScene = true
            }) {
                Image(systemName: "play.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.orange)
                    .shadow(color: .orange, radius: 20, x: 0, y: 0)
                    .padding()
                    .background(
                        Circle()
                            .fill(Color.orange.opacity(0.09))
                            .shadow(radius: 10)
                    )
            }
            .padding(.bottom, 50)
            .padding(.top, 200)

    }
        .navigationDestination(isPresented: $navigateToOpeningScene) {
            OpeningScene()
                }
    }
}

#Preview {
    StartingPage()
}
