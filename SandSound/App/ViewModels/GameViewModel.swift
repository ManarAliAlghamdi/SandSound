import Foundation
import AVFoundation
import SwiftUI

class GameViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var leftArrowOffset: CGFloat = 0
    @Published var rightArrowOffset: CGFloat = 0
    @Published var showLeftArrow: Bool = false
    @Published var showRightArrow: Bool = false
    
    @Published var tutrioalComplete = false
    @Published var showStartingPage = false
    @Published var showHomePage = false
    @Published var showOpeningScene = false
    @Published var showTutorial = false
    @Published var showGame = false
    @Published var showEndingScene = false
    var player: AVPlayer?
    
    @Published var currentMode: gameMode
    @Published var gameTimeRemaining: TimeInterval
    @Published var gameDuration: TimeInterval
    @Published var tempTimer: TimeInterval = 0
    @Published var gameTimer: Timer?
    @Published var gameEnds = false
    @Published var gameOver = false
    
    @Published var currentLane: Int = 1
    @Published var currentlevel: Int = 0
    @Published var gameMood: gameMode
    
    @Published var currentTime: TimeInterval = 0
    @Published var backgroundSound: String = ""

    var obstacles: [ObstacleModel]{
        switch gameMood {
        case .tutorial:
             tutorialObstacles
        case .game:
           gameObstacles
        }
    }
    var dialogs: [DialogModel]{
        switch gameMood {
        case .tutorial:
            tutorialDialog
        case .game:
            gameDialog
        }
    }
    
    
    var soundManager = SoundManager()
    
    // MARK: - Data Models - Tutorial
    let tutorialObstacles: [ObstacleModel] = [
        ObstacleModel(levelNo: 1, obstacleLane: 0, appearenceTime: 3, preObstacleSoundDelay: 0, duration: 0, collisionSound: "hit2.mp3", obstacleSounds: [
            ObstacleSound(obstacleSoundName: "dogBarking.wav", laneNo: 0),
            ObstacleSound(obstacleSoundName: "dogBarking.wav", laneNo: 1),
            ObstacleSound(obstacleSoundName: "dogBarking.wav", laneNo: 2)
        ]),
        
        ObstacleModel(levelNo: 2, obstacleLane: 2, appearenceTime: 6, preObstacleSoundDelay: 0, duration: 0, collisionSound: "hit2.mp3", obstacleSounds: [
            ObstacleSound(obstacleSoundName: "dogBarking.wav", laneNo: 0),
            ObstacleSound(obstacleSoundName: "dogBarking.wav", laneNo: 1),
            ObstacleSound(obstacleSoundName: "dogBarking.wav", laneNo: 2)
        ]),
       
    ]
    
    let tutorialDialog: [DialogModel] = [
        DialogModel(dialogSoundName: "tutLeft.wav", dialogApperance: 3),
        DialogModel(dialogSoundName: "tutRight.wav", dialogApperance: 6),
    ]
    
    
    // MARK: - Data Models - Game
    let gameObstacles: [ObstacleModel] = [
//        ObstacleModel(levelNo: 0, obstacleLane: 2, appearenceTime: 1, preObstacleSoundDelay: 0, duration: 0, collisionSound: "hit2.mp3", obstacleSounds: [
//            ObstacleSound(obstacleSoundName: "leftRick.mp3", laneNo: 0),
//            ObstacleSound(obstacleSoundName: "middleRick.mp3", laneNo: 1),
//            ObstacleSound(obstacleSoundName: "rightRick.mp3", laneNo: 2)
//        ]),

        // Obstacle 1 - Starts at 5s, lasts 16s (ends at 21s)
        ObstacleModel(levelNo: 0, obstacleLane: 1, appearenceTime: 5, preObstacleSoundDelay: 4, duration: 8, collisionSound: "hit2.mp3", obstacleSounds: [
            ObstacleSound(obstacleSoundName: "ob1-0.mp3", laneNo: 0),
            ObstacleSound(obstacleSoundName: "ob1-1.mp3", laneNo: 1),
            ObstacleSound(obstacleSoundName: "ob1-2.mp3", laneNo: 2)
        ]),
       
        // Obstacle 2 - Starts at 23s (21 + 2), lasts 9s (ends at 32s)
        ObstacleModel(levelNo: 1, obstacleLane: 0, appearenceTime: 23, preObstacleSoundDelay: 4, duration: 9, collisionSound: "hit2.mp3", obstacleSounds: [
            ObstacleSound(obstacleSoundName: "ob2-0.mp3", laneNo: 0),
            ObstacleSound(obstacleSoundName: "ob2-1.mp3", laneNo: 1),
            ObstacleSound(obstacleSoundName: "ob2-2.mp3", laneNo: 2)
        ]),
        
        // Obstacle 3 - Starts at 34s (32 + 2), lasts 21s (ends at 55s)
        ObstacleModel(levelNo: 2, obstacleLane: 2, appearenceTime: 34, preObstacleSoundDelay: 4, duration: 8, collisionSound: "hit2.mp3", obstacleSounds: [
            ObstacleSound(obstacleSoundName: "ob3-0.mp3", laneNo: 0),
            ObstacleSound(obstacleSoundName: "ob3-1.mp3", laneNo: 1),
            ObstacleSound(obstacleSoundName: "ob3-2.mp3", laneNo: 2)
        ]),
        
        // Obstacle 4 - Starts at 57s (55 + 2), lasts 16s (ends at 73s)
        ObstacleModel(levelNo: 3, obstacleLane: 1, appearenceTime: 68, preObstacleSoundDelay: 4, duration: 16, collisionSound: "hit2.mp3", obstacleSounds: [
            ObstacleSound(obstacleSoundName: "ob4-0.mp3", laneNo: 0),
            ObstacleSound(obstacleSoundName: "ob4-1.mp3", laneNo: 1),
            ObstacleSound(obstacleSoundName: "ob4-2.mp3", laneNo: 2)
        ])
    ]


    let gameDialog: [DialogModel] = [
        DialogModel(dialogSoundName: "dialog-After-ob3.mp3", dialogApperance: 58),
    ]
    
    
    // MARK: - Initialization
    init(gameDuration: TimeInterval, gameMode: gameMode) {
        self.gameTimeRemaining = gameDuration
        self.gameDuration = gameDuration
        self.gameMood = gameMode
        self.currentMode = gameMode
        
    
    }
    
    // MARK: - Game Timer Management
    func setupGameTimer(gameMode: gameMode) {
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            print("\(gameTimeRemaining)")
            if gameTimeRemaining > 0 {
                checkDialogAppearance()
                checkObstacleAppearance()
                tempTimer += 1
                gameTimeRemaining -= 1
                loesGame()
               
            } else {
                stopGame()
                if gameMode == .game{
                    gameEnds = true
                    
                }else if gameMode == .tutorial{
                    tutrioalComplete = true
                }
            }
        }
    }
    
    func switchMode(to mode: gameMode, duration: TimeInterval, backgroundSound: String) {
        stopGame()  // Pause the current game
        gameMood = mode
        tempTimer = 0
        currentLane = 1
        gameTimeRemaining = duration
        gameDuration = duration
        setupGameTimer(gameMode: mode)  // Restart timer for new mode
        print("Switched to \(mode)")
        soundManager.playSoundFromFile(named: backgroundSound, player: &soundManager.backgroundAudioPlayer, soundInLoop: true)
    }
        
    
    
    func restartGame(backgroundSound: String) {
        stopGame()  
        gameOver = false
        gameEnds = false
        tempTimer = 0
        gameTimeRemaining = gameDuration
        currentLane = 1
        currentlevel = 0
        
        soundManager.stopAllSounds()
        soundManager.playSoundFromFile(named: "backgroundSound.wav", player: &soundManager.backgroundAudioPlayer, soundInLoop: true)
        
        setupGameTimer(gameMode: gameMood)  // Restart the timer
        print("Game Restarted")
    }

    func pauseGameTimer() {
        gameTimer?.invalidate()
        print("Game Paused")
    }
    
    func resumeGameTimer() {
        setupGameTimer(gameMode: gameMood)
        print("Game Resumed")
    }
    
    func stopGame() {
        gameTimer?.invalidate()
        soundManager.stopAllSounds()
    }
    
    
    func loesGame() {
        let elapsedTime = gameDuration - gameTimeRemaining
        // Check for a collision
        for obstacle in obstacles {
            let obstacleStartTime = obstacle.appearenceTime
            let obstacleEndTime = obstacle.appearenceTime + obstacle.ObstacleDuration
            
            // If the obstacle is currently active
            if elapsedTime >= obstacleStartTime && elapsedTime <= obstacleEndTime {
                // Check if the user is in the same lane as the obstacle
                if currentLane == obstacle.obstacleLane {
                    // User loses the game
                    gameOver = true
                    stopGame()
                    soundManager.playSoundFromFile(named: obstacle.collisionSound, player: &soundManager.collisionAudioPlayer)
                    soundManager.currentTime = 0 
                    print("User lost the game due to collision with obstacle at lane \(obstacle.obstacleLane)")
                    return
                }
            }
        }
    }

    // MARK: - Swipe Handling
    @Published var lastSwipeTime: TimeInterval = 0

func handleSwipe(direction: SwipeDirection) {
    let now = Date().timeIntervalSince1970
    guard now - lastSwipeTime > 0.3 else {
        // If it's within 300 ms of the last swipe, ignore
        return
    }
    lastSwipeTime = now
    
    print("fuck you \(gameObstacles[currentlevel].obstacleSounds[currentLane].obstacleSoundName)")
    
    switch direction {
    case .left:
        if currentLane > 0 {
            currentLane -= 1
            if soundManager.obstaclePlayer != nil {
                if soundManager.obstaclePlayer!.isPlaying {
                    if gameMood == .game {
                        soundManager.switchSound(to: gameObstacles[currentlevel].obstacleSounds[currentLane].obstacleSoundName)
                        
                    }
                }
                if showLeftArrow {
                    hideArrows("left")
                    soundManager.stopSound(for: &soundManager.obstaclePlayer)
                    resumeGameTimer()
                }
            }
        }
    case .right:
        if currentLane < 2 {
            currentLane += 1
            if soundManager.obstaclePlayer != nil {
                if soundManager.obstaclePlayer!.isPlaying {
                    if gameMood == .game {
                        soundManager.switchSound(to: gameObstacles[currentlevel].obstacleSounds[currentLane].obstacleSoundName)
                        
                    }
                }
            }
            if showRightArrow {
                hideArrows("right")
                soundManager.stopSound(for: &soundManager.obstaclePlayer)
                resumeGameTimer()
            }
        }
    }
}
    func skipVideo() {
            print("Skipping video")
            showHomePage = true
        }
    
    
   
    
    // MARK: - Arrow Handling
    func hideArrows(_ leftOrRight: String) {
        DispatchQueue.main.async {
            withAnimation(.easeInOut(duration: 0.5)) {
                if leftOrRight == "left" {
                    self.showLeftArrow = false
                } else if leftOrRight == "right" {
                    self.showRightArrow = false
                }
            }
        }
    }
    
    // MARK: - Obstacle and Dialog Management
    func checkDialogAppearance() {
        let elapsedTime = gameDuration - gameTimeRemaining
        for dialog in dialogs {
            if Int(dialog.dialogApperance) == Int(elapsedTime) {
                soundManager.playSoundFromFile(named: dialog.dialogSoundName, player: &soundManager.dialogPlayer)
            }
        }
    }
    
    func checkObstacleAppearance() {
        let elapsedTime = gameDuration - gameTimeRemaining
        for obstacle in obstacles {
            let triggerTime = getTriggerTime(for: obstacle)
            
            if Int(triggerTime) == Int(elapsedTime) {
                currentlevel = obstacle.levelNo

                handleObstacleTrigger(obstacle)
            }
        }
    }
    
    private func getTriggerTime(for obstacle: ObstacleModel) -> TimeInterval {
        switch gameMood {
        case .tutorial:
            return obstacle.appearenceTime
        case .game:
            return obstacle.appearenceTime - obstacle.preObstacleSoundDelay
        }
    }
    
    private func handleObstacleTrigger(_ obstacle: ObstacleModel) {
        if gameMood == .tutorial {
            handleArrowTutorial(for: obstacle)
        }
        playObstacleSound(obstacle)
    }
    
    private func handleArrowTutorial(for obstacle: ObstacleModel) {
        if obstacle.obstacleLane == 0 && !showLeftArrow {
            showLeftArrow = true
            pauseGameTimer()
        } else if obstacle.obstacleLane == 2 && !showRightArrow {
            showRightArrow = true
            pauseGameTimer()
        }
    }
    
    private func playObstacleSound(_ obstacle: ObstacleModel) {
        soundManager.switchSound(to: obstacle.obstacleSounds[currentLane].obstacleSoundName)
//        soundManager.playSoundFromFile(
//            named: obstacle.obstacleSounds[currentLane].obstacleSoundName,
//            player: &soundManager.obstaclePlayer
//        )
    }
    
    
    // MARK: - Enums
    enum SwipeDirection {
        case left
        case right
    }
    
    enum gameMode {
        case tutorial
        case game
    }
}
