//
//  SandSoundApp.swift
//  SandSound
//
//  Created by Manar Alghmadi on 21/12/2024.
//

import SwiftUI

@main
struct SandSoundApp: App {
    var body: some Scene {
        WindowGroup {
//            Game()
          SplashScreen()
                .preferredColorScheme(.dark)//Forces the app to use dark mode globally
        }
    }
}
