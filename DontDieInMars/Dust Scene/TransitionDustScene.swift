//
//  Transition-Dust.swift
//  DontDieInMars
//
//  Created by Rio Ikhsan on 01/05/24.
//


import Foundation
import SpriteKit
import AVFoundation

class TransitionDustScene: SKScene {
    
    private var backgroundMusicPlayer: AVAudioPlayer!
    
    let background = SKSpriteNode(imageNamed: "transition-dust")
    
    
    override func didMove(to view: SKView) {
        setUpBgm()
        background.size = self.size
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = 1
        addChild(background)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let game = TransitionDustAnnoucementScene(size: self.size)
        let transition = SKTransition.fade(with: .black, duration: 2)
        
        self.view?.presentScene(game, transition: transition)
    }
    
    func setUpBgm(){
        // Load and play background music
        if let musicURL = Bundle.main.url(forResource: "strong-desert-wind", withExtension: "mp3") {
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
