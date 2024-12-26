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
