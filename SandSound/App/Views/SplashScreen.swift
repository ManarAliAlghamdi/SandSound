
import SwiftUI

struct SplashScreen: View {
    @EnvironmentObject var viewModel: GameViewModel

    @State private var opacity = 0.0

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                if viewModel.showStartingPage {
                    StartingPage()
                } else if !viewModel.showStartingPage{
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 1000, height: 1000)
                        .padding()
                        .onAppear {
                            withAnimation(.easeInOut(duration: 1.5)) {
                                opacity = 1.0
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                withAnimation {
                                    viewModel.showStartingPage = true
                                }
                            }
                        }
                }
            }
        }
    }
}

#Preview {
    SplashScreen()
}

