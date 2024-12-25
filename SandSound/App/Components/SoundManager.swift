
import AVFoundation
import Foundation

class SoundManager{
    
    var  dialogPlayer: AVAudioPlayer?
    var  obstaclePlayer: AVAudioPlayer?
    var  backgroundAudioPlayer: AVAudioPlayer?
    var  collisionAudioPlayer: AVAudioPlayer?
    var  stopTimers: [String: Timer] = [:]
    var currentTime: TimeInterval = 0

    
    func getAudioURL(named soundName: String) -> URL? {
        guard let path = Bundle.main.path(forResource: soundName, ofType: nil) else {
            print("Sound file not found: \(soundName)")
            return nil
        }
        return URL(fileURLWithPath: path)
    }

    
    func initializeAudioPlayer(url: URL) -> AVAudioPlayer? {
        do {
            return try AVAudioPlayer(contentsOf: url)
        } catch {
            print("Failed to initialize audio player: \(error.localizedDescription)")
            return nil
        }
    }

    
    func controlSoundPlayback(player: AVAudioPlayer, duration: TimeInterval?, at time: TimeInterval = 0) {
        player.currentTime = time
        player.play()
        if let duration = duration {
            let playerKey = "\(Unmanaged.passUnretained(player).toOpaque())"
            stopTimers[playerKey]?.invalidate()
            stopTimers[playerKey] = Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { [weak player] _ in
                player?.stop()
            }
        }
    }

    func playSoundFromFile(named soundName: String, player: inout AVAudioPlayer?, duration: TimeInterval? = nil, soundInLoop: Bool = false, at time: TimeInterval = 0) {
        guard let url = self.getAudioURL(named: soundName) else { return }
        guard let audioPlayer = self.initializeAudioPlayer(url: url) else { return }
        player = audioPlayer
        audioPlayer.numberOfLoops = soundInLoop ? -1 : 0
        self.controlSoundPlayback(player: audioPlayer, duration: duration, at: time)
    }
    
    
    func switchSound(to soundName: String) {
        currentTime = obstaclePlayer?.currentTime ?? 0
        obstaclePlayer?.stop()
        playSoundFromFile(named: soundName, player: &obstaclePlayer, at: currentTime)
    }

    func stopAllSounds(){
        dialogPlayer?.stop()
        backgroundAudioPlayer?.stop()
        obstaclePlayer?.stop()
        collisionAudioPlayer?.stop()

    }
    
   
    
    func stopSound(for player: inout AVAudioPlayer?) {
        player?.stop()
        player = nil
    }
    
    
    
}
