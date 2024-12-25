import SwiftUI
import CoreHaptics

struct GameTutorial: View {
    @ObservedObject var viewModel = GameViewModel(gameDuration: 10, gameMode: .tutorial, bacgroundSound: "backgroundSound.wav")
    
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
                                    UIAccessibility.post(notification: .layoutChanged, argument: "Swipe left to avoid obstacle")
                                }
                                .accessibilityLabel("Swipe left to avoid obstacle")
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
                                    UIAccessibility.post(notification: .layoutChanged, argument: "Swipe right to avoid obstacle")
                                }
                                .accessibilityLabel("Swipe right to avoid obstacle")
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
                } else if viewModel.navigateToPlay {
                    Game()
                }
            }
        }
        .simultaneousGesture(
            DragGesture()
                .onEnded { value in
                    let horizontalDistance = value.translation.width
                    if horizontalDistance < -50 {
                        viewModel.handleSwipe(direction: .left)
                        UIAccessibility.post(notification: .layoutChanged, argument: "Swiped left")
                    } else if horizontalDistance > 50 {
                        viewModel.handleSwipe(direction: .right)
                        UIAccessibility.post(notification: .layoutChanged, argument: "Swiped right")
                    }
                }
        )
        .accessibilityAction(named: "Swipe Left") {
            viewModel.handleSwipe(direction: .left)
        }
        .accessibilityAction(named: "Swipe Right") {
            viewModel.handleSwipe(direction: .right)
        }
    }
}

#Preview {
    GameTutorial()
}
