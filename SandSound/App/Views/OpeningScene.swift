
import SwiftUI
import AVKit

// تخصيص فيديو بدون عناصر تحكم
struct FullScreenVideoPlayer: UIViewControllerRepresentable {
    let videoName: String
    let videoExtension: String

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        
        if let path = Bundle.main.path(forResource: videoName, ofType: videoExtension) {
            let url = URL(fileURLWithPath: path)
            let player = AVPlayer(url: url)
            controller.player = player
            controller.showsPlaybackControls = false
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
            ZStack {
                FullScreenVideoPlayer(videoName: "video", videoExtension: "MP4")
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
            .navigationDestination(isPresented: $navigateToPlay) {
                GameTutorial()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

