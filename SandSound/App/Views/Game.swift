
import SwiftUI

struct Game: View {
    @ObservedObject var viewModel: GameViewModel = GameViewModel(gameDuration: 20, gameMode: .game)
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack {
                if !viewModel.navigateToPlay{

                    if viewModel.gameOver {
                        Text("Game Over \n you lost").font(.largeTitle).foregroundStyle(Color.white)
                    }
                    if !viewModel.gameEnds {
                        
                        Text("Current line: \(viewModel.currentLane)").foregroundStyle(Color.white)
                        Text("Game Timer: \(viewModel.tempTimer)").foregroundStyle(Color.white)
                    }
                    if viewModel.gameEnds {
                        FullScreenVideoPlayer(videoName: "Win", videoExtension: "mov", isVideoEnded: $viewModel.navigateToPlay)
                            .ignoresSafeArea()
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Button(action: {
                                    viewModel.navigateToPlay = true
                                }) {
                                    
                                    Text("Skip").foregroundColor(.white)
                                    Image(systemName: "forward.fill").foregroundColor(.white)
                                }
                                .padding(.trailing, 30)
                                .padding(.bottom, 30)
                            }
                        }
                    }
                    }else if viewModel.navigateToPlay{
                        StartingPage()
                    }
                
            }
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
