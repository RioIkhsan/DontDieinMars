//
//  EndingScene.swift
//  DontDieInMars
//
//  Created by Rio Ikhsan on 01/05/24.
//

import Foundation
import SpriteKit
import AVFoundation

class EndingScene: SKScene {
    
    private var backgroundMusicPlayer: AVAudioPlayer!
    let background = SKSpriteNode(imageNamed: "ending-scene")
    let astronautEnd = SKSpriteNode(imageNamed: "astronaut-ending")

    
    
    override func didMove(to view: SKView) {
        setUpBgm()
        background.size = self.size
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = 1
        addChild(background)
        
        astronautEnd.position = CGPoint(x: -100, y: 30)
        astronautEnd.zPosition = 1
        addChild(astronautEnd)
        
        let moveAction = SKAction.move(to: CGPoint(x: 80, y: 30), duration: 1)
        astronautEnd.run(moveAction)
        
        let waitAction = SKAction.wait(forDuration: 3)
        let changeColorAction = SKAction.colorize(with: .black, colorBlendFactor: 1, duration: 1)
        let sequenceAction = SKAction.sequence([waitAction, changeColorAction])
        background.run(sequenceAction)
        astronautEnd.run(sequenceAction)
        
    }
    
    func setUpBgm(){
        // Load and play background music
        if let musicURL = Bundle.main.url(forResource: "intro-spooky", withExtension: "mp3") {
            print("masuk if {}")
            do {
                backgroundMusicPlayer = try AVAudioPlayer(contentsOf: musicURL)

                playAudioWithDelay(delay: 0.2)
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
