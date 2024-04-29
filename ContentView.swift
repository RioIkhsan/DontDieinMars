//
//  ContentView.swift
//  DontDieInMarsSelfMade
//
//  Created by Tania Cresentia on 25/04/24.
//

import SwiftUI
import SpriteKit
import AVFoundation

class StartScene: SKScene {
    
    private var ufo = SKTexture(imageNamed: "ufo")
    var backgroundMusicPlayer: AVAudioPlayer!
    
    override func didMove(to view: SKView) {
        self.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        scene?.scaleMode = .aspectFill
       // setUpBgm()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let startNode = atPoint(location)
            
            if startNode.name == "ufo" {
                let game = GameScene(size: self.size)
                let transition = SKTransition.fade(with: .black, duration: 3)
                
                self.view?.presentScene(game, transition: transition)
            }
        }
    }
    
    func setUpBgm(){
        // Load and play background music
        if let musicURL = Bundle.main.url(forResource: "startingpage-spooky", withExtension: "mp3") {
            print("masuk if {}")
            do {
                backgroundMusicPlayer = try AVAudioPlayer(contentsOf: musicURL)
//                backgroundMusicPlayer.numberOfLoops = -1 // Loop indefinitely
                playAudioWithDelay(delay: 2.0)
                
                print("masuk do {}")
            } catch {
                print("Error loading background music: \(error)")
            }
        } else {
            print("ga masuk if {}")
        }
    }
    
    // Function to play audio with delay
        func playAudioWithDelay(delay: TimeInterval) {
            // Calculate the time to play audio
            let delayTime = CACurrentMediaTime() + delay
            // Schedule playback with the calculated time
            backgroundMusicPlayer?.play(atTime: delayTime)
        }
}

struct ContentView: View {
    let startScene = StartScene(fileNamed: "StartScene")
    
    var body: some View {
        SpriteView(scene: startScene!)
            .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}
