import SwiftUI

struct GameTutorial: View {
    @ObservedObject var viewModel = GameViewModel(gameDuration: 10, gameMode: .tutorial)
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack {
                if !viewModel.navigateToPlay{
                    if !viewModel.gameEnds {
                        if viewModel.showLeftArrow {
                            Image("leftArrow")
                                .resizable()
                                .frame(width: 200, height: 120)
                                .offset(x: viewModel.leftArrowOffset)
                                .onAppear {
                                    withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                                        viewModel.leftArrowOffset = -30
                                    }
                                }
                                .transition(.opacity)
                        } else if viewModel.showRightArrow {
                            Image("rightArrow")
                                .resizable()
                                .frame(width: 200, height: 120)
                                .offset(x: viewModel.rightArrowOffset)
                                .onAppear {
                                    withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                                        viewModel.rightArrowOffset = -30
                                    }
                                }
                                .transition(.opacity)
                        }
                    }
                    
                    
                    if viewModel.gameEnds {
                        ZStack{
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
                        
                    }
                }else if viewModel.navigateToPlay{
                    Game()
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
    GameTutorial()
}
