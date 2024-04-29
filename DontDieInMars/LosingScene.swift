//
//  LosingScene.swift
//  DontDieInMars
//
//  Created by Tania Cresentia on 29/04/24.
//

import Foundation
import SpriteKit

class LosingScene: SKScene {
    
    let background = SKSpriteNode(imageNamed: "clean-of-dust")
    let liquid1 = SKSpriteNode(imageNamed: "liquid1")
    let liquid2 = SKSpriteNode(imageNamed: "liquid2")
    let liquid3 = SKSpriteNode(imageNamed: "liquid3")
    let liquid4 = SKSpriteNode(imageNamed: "liquid4")
    let liquid5 = SKSpriteNode(imageNamed: "liquid5")
    let ghost = SKSpriteNode(imageNamed: "ghost")

    
    func createFadeInSequence(waitDuration: TimeInterval, fadeInDuration: TimeInterval) -> SKAction {
        let fadeInAction = SKAction.fadeIn(withDuration: fadeInDuration)
        let waitAction = SKAction.wait(forDuration: waitDuration)
        let fadeInSequence = SKAction.sequence([waitAction, fadeInAction])
        return fadeInSequence
    }
    
   
    override func didMove(to view: SKView) {
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = 1
        addChild(background)

        liquid1.position = CGPoint(x: 0, y: size.height)
        liquid1.size = CGSize(width: 600, height: 600)
        liquid1.zPosition = 2
        liquid1.alpha = 0
        addChild(liquid1)

        liquid2.position = CGPoint(x: size.width, y: size.height)
        liquid2.size = CGSize(width: 500, height: 500)
        liquid2.zPosition = 2
        liquid2.alpha = 0
        addChild(liquid2)

        liquid3.position = CGPoint(x: size.width, y: 0)
        liquid3.size = CGSize(width: 500, height: 500)
        liquid3.zPosition = 2
        liquid3.alpha = 0
        addChild(liquid3)
        
        liquid4.position = CGPoint(x: size.width/2, y: size.height/2)
        liquid4.size = CGSize(width: 600, height: 600)
        liquid4.zPosition = 2
        liquid4.alpha = 0
        addChild(liquid4)

        liquid5.position = CGPoint(x: 0, y: 0)
        liquid5.size = CGSize(width: 300, height: 300)
        liquid5.zPosition = 2
        liquid5.alpha = 0
        addChild(liquid5)
        
        ghost.size = CGSize(width: 150, height: 150)
        ghost.position = CGPoint(x: size.width / 2, y: 0)
        ghost.zPosition = 2
        ghost.alpha = 0
        addChild(ghost)
        
        let waitAction = SKAction.wait(forDuration: 4)
        let fadeInAction = SKAction.fadeIn(withDuration: 2)
        let moveAction = SKAction.move(to: CGPoint(x: size.width / 2, y: size.height), duration: 3)
        let fadeOutAction = SKAction.fadeOut(withDuration: 1)
        let groupAction = SKAction.group([fadeInAction, moveAction])
        let fullSequence = SKAction.sequence([waitAction, groupAction ,fadeOutAction])


        liquid1.run(createFadeInSequence(waitDuration: 3, fadeInDuration: 3))
        liquid2.run(createFadeInSequence(waitDuration: 2, fadeInDuration: 3))
        liquid3.run(createFadeInSequence(waitDuration: 3, fadeInDuration: 3))
        liquid4.run(createFadeInSequence(waitDuration: 2, fadeInDuration: 3))
        liquid5.run(createFadeInSequence(waitDuration: 3, fadeInDuration: 3))
        ghost.run(fullSequence)
    }
}
