
import SwiftUI

struct Game: View {
    @ObservedObject var viewModel: GameViewModel = GameViewModel(gameDuration: 20, gameMode: .game)
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack {
                if !viewModel.navigateToPlay{
                    
                    if !viewModel.gameOver {
                        
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
                    } else if viewModel.gameOver {
                        VStack {
                            Spacer().frame(height: 30)

//                            VStack {
////                                Text("انهزمت")
////                                    .font(.largeTitle)
////                                    .fontWeight(.bold)
////                                    .foregroundColor(myColors.customGold)
////                                    .shadow(radius: 5)
//                            }
                            
                            Text(" اركض اسرع المرة الجايه ...")
                                .foregroundColor(.white)
                                .italic()
                            
                            Spacer().frame(height: 30)
                            
//                            HStack(spacing: 20) {
//                                Button(action: {
//                                    viewModel.restartGame()
//                                    viewModel.gameOver = false
//                                }) {
//                                    HStack {
//                                        Image(systemName: "gobackward")
//                                        Text(" الرئيسية")
//                                    }
//                                    .padding()
//                                    .frame(maxWidth: .infinity)
//                                    .background(myColors.brightOrange.opacity(0.7))
//                                    .foregroundColor(.white)
//                                    .cornerRadius(10)
//                                }
                                Button(action: {
                                    viewModel.navigateToPlay = true  // Go to main menu
                                    viewModel.gameOver = false
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
//                        }                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
	
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
