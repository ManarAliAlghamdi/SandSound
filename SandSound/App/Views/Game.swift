
import SwiftUI

struct Game: View {
    @EnvironmentObject var viewModel: GameViewModel
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack {
                if !viewModel.showEndingScene{
                    
                    if !viewModel.gameOver {
                        
                        if !viewModel.gameEnds {
                            Text("Current line: \(viewModel.currentLane)").foregroundStyle(Color.white)
                            Text("Game Timer: \(viewModel.tempTimer)").foregroundStyle(Color.white)
                        }
                        if viewModel.gameEnds {
                            FullScreenVideoPlayer(videoName: "Win", videoExtension: "mov", isVideoEnded: $viewModel.showEndingScene)
                                .ignoresSafeArea()
                            VStack {
                                Spacer()
                                HStack {
                                    Spacer()
                                    Button(action: {
                                        viewModel.showEndingScene = true
                                    }) {
                                        
                                        Text("Skip").foregroundColor(.white)
                                        Image(systemName: "forward.fill").foregroundColor(.white)
                                    }
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
                            
                            Spacer().frame(height: 30)

                                Button(action: {
                                    viewModel.restartGame()
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
                                }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                            }
                        .padding(40)
                        .frame(maxWidth: 400)
                        .background(
                            Image("gameOver")  
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

                }else if viewModel.showEndingScene{
                    StartingPage()
                }
                
            }
        }
        .gesture(
            DragGesture()
                .onEnded { value in
            if !viewModel.gameOver {
                    let horizontalDistance = value.translation.width
                    if horizontalDistance < -50 {
                        viewModel.handleSwipe(direction: .left)
                    } else if horizontalDistance > 50 {
                        viewModel.handleSwipe(direction: .right)
                    }
                    
                }
            }
        )
    }
}
#Preview {
    Game()
}
