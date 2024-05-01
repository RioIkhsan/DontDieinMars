//
//  WinningScene.swift
//  DontDieInMars
//
//  Created by Tania Cresentia on 29/04/24.
//

import Foundation
import SpriteKit

class WinningScene: SKScene {
    
    private var background = SKSpriteNode(imageNamed: "background")
    private var astronaut = SKSpriteNode(imageNamed: "run1")
    private var astronautTextures: [SKTexture] = []
    
    override func didMove(to view: SKView) {
        backgroundColor = .blue
        
        addBackground()
        loadAstronaut()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if background.contains(location) {
                
                let game = MeteorScene(size: self.size)
                let transition = SKTransition.fade(with: .black, duration: 3)
                
                self.view?.presentScene(game, transition: transition)
            }
        }
    }
    
    func addBackground() {
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = 1
        addChild(background)
    }
    
    func loadAstronaut() {
        for i in 1...2 {
            let texture = SKTexture(imageNamed: "run\(i)")
            astronautTextures.append(texture)
        }
        
        astronaut = SKSpriteNode(texture: astronautTextures[0])
        astronaut.position = CGPoint(x: size.width/8, y: size.height/4)
        astronaut.zPosition = 2
        astronaut.setScale(0.05)
        addChild(astronaut)
        
        let animateAstronaut = SKAction.animate(with: astronautTextures, timePerFrame: 0.25)
        
        let repeatAction = SKAction.repeatForever(animateAstronaut)
        
        astronaut.run(repeatAction)
        astronaut.run(SKAction.moveBy(x: 700, y: 0, duration: 7.0))
        
        if astronaut.position.x > size.width/2 {
                moveToMeteorScene()
            print("Sprite node went out of the X frame")
        } else {
            print("Astronaut position")
            print(astronaut.position.x)
            print("size.width/2")
            print(size.width/2)
        }
        
    }
    
    func moveToMeteorScene() {
        let game = StartScene(size: self.size)
        let transition = SKTransition.fade(with: .black, duration: 3)
        
        self.view?.presentScene(game, transition: transition)
    }
    
}
