
import SwiftUI

struct Game: View {
    @EnvironmentObject var viewModel: GameViewModel
    @State var showHomePage: Bool = false
    
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack {
                if !viewModel.showHomePage{
                    
                    if !viewModel.gameOver {
                        
                        if viewModel.gameEnds {
                            FullScreenVideoPlayer(videoName: "Win", videoExtension: "mov", isVideoEnded: $viewModel.showHomePage)
                                .ignoresSafeArea()
//                                .accessibilityLabel("Wining video")
//                                .accessibilityHint("Plays a video for winning the game.")
                            
                            VStack {
                                Spacer()
                                HStack {
                                    Spacer()
                                    Button(action: {
                                        viewModel.showHomePage = true
                                       
                                    }) {
                                        
                                        Text("Skip").foregroundColor(.white)
                                        Image(systemName: "forward.fill").foregroundColor(.white)
                                    }
                                    .accessibilityLabel("Skip Victory Video")
                                    .accessibilityHint("Skips the video and goes back to the home page.")
                                     .padding(.trailing, 30)
                                    .padding(.bottom, 30)
                                }
                            }
                        }
                    } else if viewModel.gameOver {
                        VStack {
                            Spacer().frame(height: 30)

                            
                            Text(" اركض اسرع المرة الجايه ...")
                                .foregroundColor(.white)
                                .italic()
                                .accessibilityLabel("Run faster next time.")
                            
                            Spacer().frame(height: 30)
                            

                                Button(action: {
//                                    viewModel.navigateToPlay = true  // Go to main menu
                                    viewModel.gameOver = false
                                    viewModel.restartGame(backgroundSound: "full-background.mp3")
                                }) {
                                    HStack {
                                        Image(systemName: "arrow.clockwise")
                                        Text("العب مرة ثانية")
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.white.opacity(0.09))
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                }
                                .accessibilityLabel("Play again")
                                .accessibilityHint("Restarts the game.")
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                            }

                        .padding(40)
                        .frame(maxWidth: 400)
                        .background(
                            Image("gameOver")  // Replace with your image name
                                .resizable()
                                .scaledToFill()
                                .edgesIgnoringSafeArea(.all)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 25, style: .continuous)
                                .stroke(myColors.darkNavy.opacity(0.8), lineWidth: 2)
                        )
                        .shadow(radius: 15)
                        .scaleEffect(1.1)
                        .transition(.opacity.combined(with: .scale))
                        .animation(.spring())

                    }

                }else if  viewModel.showHomePage{
                    StartingPage()
                        .accessibilityLabel("Home Page")
                        .accessibilityHint("Navigate to the starting page.")
                    
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
