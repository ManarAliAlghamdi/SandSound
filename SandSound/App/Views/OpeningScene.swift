
import SwiftUI
import AVKit

struct FullScreenVideoPlayer: UIViewControllerRepresentable {
    let videoName: String
    let videoExtension: String
    @Binding var isVideoEnded: Bool  // Binding to track video end status

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        
        if let path = Bundle.main.path(forResource: videoName, ofType: videoExtension) {
            let url = URL(fileURLWithPath: path)
            let player = AVPlayer(url: url)
            controller.player = player
            controller.showsPlaybackControls = false
            
            // Observe when the video ends
            NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                                                   object: player.currentItem,
                                                   queue: .main) { _ in
                print("Video has ended")
                isVideoEnded = true  // Update the binding when video ends
            }
            
            player.play()
        }
        
        return controller
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {}
}

struct OpeningScene: View {
    @State private var navigateToPlay = false

    var body: some View {
        NavigationStack {
            if !navigateToPlay{
                ZStack {
                    FullScreenVideoPlayer(videoName: "video", videoExtension: "MP4", isVideoEnded: $navigateToPlay)
                        .ignoresSafeArea()
                    
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button(action: {
                                navigateToPlay = true
                            }) {
                                Text("Skip")
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.black.opacity(0.7))
                                    .cornerRadius(10)
                                    .padding(10)
                            }
                           
                        }
                    }
                }
              
            }else if navigateToPlay{
                GameTutorial()
            }
        }
                .navigationBarBackButtonHidden(true)
        }
    
}
#Preview {
    OpeningScene()
}
