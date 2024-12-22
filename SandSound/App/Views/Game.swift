
import SwiftUI

struct Game: View {
    @ObservedObject var viewModel: GameViewModel = GameViewModel(gameDuration: 20, gameMode: .game)
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack {
                if viewModel.gameOver {
                    Text("Game Over \n you lost").font(.largeTitle).foregroundStyle(Color.white)
                }
                Text("Current line: \(viewModel.currentLane)").foregroundStyle(Color.white)
                Text("Game Timer: \(viewModel.tempTimer)").foregroundStyle(Color.white)
            }
            if viewModel.gameEnds {
                VideoPlayerView(videoName: "Win") {
                    viewModel.navigateToContentView = true
                }
                .edgesIgnoringSafeArea(.all)
                .overlay(
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button(action: {
                                viewModel.navigateToContentView = true
                            }) {
                                
                                Text("Skip").foregroundColor(.white)
                                Image(systemName: "forward.fill").foregroundColor(.white)
                            }
                            .padding(.trailing, 30)
                            .padding(.bottom, 30)
                        }
                    }
                )
            }
        }.fullScreenCover(isPresented: $viewModel.navigateToContentView) {
            ContentView()  // Navigate to ContentView
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    let horizontalDistance = value.translation.width
                    if horizontalDistance < -50 {
                        viewModel.handleSwipe(direction: .left)
                    } else if horizontalDistance > 50 {
                        viewModel.handleSwipe(direction: .right)
                    }
                }
        )
    }
}
#Preview {
    Game()
}
