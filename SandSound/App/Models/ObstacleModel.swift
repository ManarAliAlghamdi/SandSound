//
//  ObstacleModel.swift
//  SandSound
//
//  Created by Manar Alghmadi on 21/12/2024.
//

import Foundation

class ObstacleSound {
    var obstacleSoundName: String
    var laneNo: Int
    
    init(obstacleSoundName: String, laneNo: Int) {
        self.obstacleSoundName = obstacleSoundName
        self.laneNo = laneNo
    }
}

class ObstacleModel: Identifiable {
    let id = UUID()
    var levelNo: Int
    var obstacleLane: Int
    var appearenceTime: TimeInterval
    var preObstacleSoundDelay: TimeInterval
    var ObstacleDuration: TimeInterval
    var collisionSound: String
    var obstacleSounds: [ObstacleSound]
    
    init(levelNo: Int, obstacleLane: Int, appearenceTime: TimeInterval, preObstacleSoundDelay: TimeInterval, duration: TimeInterval, collisionSound: String, obstacleSounds: [ObstacleSound]) {
        self.levelNo = levelNo
        self.obstacleLane = obstacleLane
        self.appearenceTime = appearenceTime
        self.preObstacleSoundDelay = preObstacleSoundDelay
        self.ObstacleDuration = duration
        self.collisionSound = collisionSound
        self.obstacleSounds = obstacleSounds
    }
}
