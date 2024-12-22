import SwiftUI

struct StartingPage: View {
    @State private var navigateToOpeningScene = false
    var body: some View {
        
        ZStack {
            Image("Background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            GifWebView(gifName: "StarryBackground")
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
                            .fill(Color.black.opacity(0.6))
                            .shadow(radius: 10)
                    )
            }
            .padding(.bottom, 50)  

    }
        .navigationDestination(isPresented: $navigateToOpeningScene) {
            OpeningScene()
                }
    }
}

#Preview {
    StartingPage()
}
