import SwiftUI
import AVKit

struct VideoPlayerView: UIViewControllerRepresentable {
    let videoName: String
    let onVideoEnd: () -> Void
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let playerViewController = AVPlayerViewController()
        playerViewController.showsPlaybackControls = false
       
//      if let url = Bundle.main.url(forResource: videoName, withExtension: "mp4")
        if let url = Bundle.main.url(forResource: videoName, withExtension: "mp4") {
            let player = AVPlayer(url: url)
            playerViewController.player = player
            
            NotificationCenter.default.addObserver(
                forName: .AVPlayerItemDidPlayToEndTime,
                object: player.currentItem,
                queue: .main
            ) { _ in
                onVideoEnd() 
            }
            
            player.play()
        }
        
        return playerViewController
    }
    
//    func stopVideo() {
//        player?.pause()
//        player?.replaceCurrentItem(with: nil)
//        player = nil
//        NotificationCenter.default.post(name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
//    }
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {}
}
