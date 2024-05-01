//
//  WinningScene1.swift
//  DontDieInMars
//
//  Created by Rio Ikhsan on 01/05/24.
//

import Foundation
import SpriteKit
import AVFoundation


class WinningScene1: SKScene {
    
    private var backgroundMusicPlayer: AVAudioPlayer!
    
    let background = SKSpriteNode(imageNamed: "winning-scene1")
    let check = SKSpriteNode(imageNamed: "checkmark")
    
    
    override func didMove(to view: SKView) {
        setUpBgm()
        
        background.size = self.size
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = 1
        addChild(background)
        
        DispatchQueue.main.asyncAfter(deadline:.now() + 1) {
            self.showCheck()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let game = MeteorScene(size: self.size)
        let transition = SKTransition.fade(with: .black, duration: 2)
        
        self.view?.presentScene(game, transition: transition)
    }
    
    func setUpBgm(){
        // Load and play background music
        if let musicURL = Bundle.main.url(forResource: "checkmark", withExtension: "mp3") {
            print("masuk if {}")
            do {
                backgroundMusicPlayer = try AVAudioPlayer(contentsOf: musicURL)
                
                playAudioWithDelay(delay: 1)
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


    // Function to show Exclamation Mark
    func showCheck() {
        check.position = CGPoint(x: size.width/2+60, y: size.height/2-65)
        check.zPosition = 2
        check.alpha = 0
        addChild(check)
        
        let fadeInAction = SKAction.fadeIn(withDuration: 0.1)
        let scaleUp = SKAction.scale(to: 1.2, duration: 0.2)
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.2)
        let sequence = SKAction.sequence([fadeInAction,scaleUp, scaleDown])
        check.run(sequence)
    }
    
}
