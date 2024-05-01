//
//  TestScene.swift
//  DontDieInMars
//
//  Created by Tania Cresentia on 30/04/24.
//

import SpriteKit

class TestScene: SKScene, SKPhysicsContactDelegate {
    
    var astronaut: SKSpriteNode!
    var meteorCount = 0
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        // Create astronaut
        astronaut = SKSpriteNode(imageNamed: "astronaut")
        astronaut.position = CGPoint(x: size.width / 2, y: size.height * 0.2)
        addChild(astronaut)
        
        // Set up astronaut's physics body
        astronaut.physicsBody = SKPhysicsBody(circleOfRadius: astronaut.size.width / 2)
        astronaut.physicsBody?.isDynamic = false // Fixed on the ground
        astronaut.physicsBody?.categoryBitMask = 1
        astronaut.physicsBody?.collisionBitMask = 0
        
        // Start spawning meteors
        startSpawningMeteors()
    }
    
    func startSpawningMeteors() {
        let spawnAction = SKAction.run { [weak self] in
            self?.spawnMeteor()
        }
        let delayAction = SKAction.wait(forDuration: 2.0) // Adjust spawn interval as needed
        let spawnSequence = SKAction.sequence([spawnAction, delayAction])
        let spawnForever = SKAction.repeatForever(spawnSequence)
        run(spawnForever)
    }
    
    func spawnMeteor() {
        if meteorCount < 5 {
            let meteor = SKSpriteNode(imageNamed: "meteor")
            addChild(meteor)
            
            // Set meteor's initial position and physics properties
            var initialPosition = CGPoint()
            var velocity = CGVector()
            if meteorCount % 2 == 0 {
                // Move from upper left to lower right
                initialPosition = CGPoint(x: 0, y: size.height)
                velocity = CGVector(dx: 200, dy: -200)
            } else {
                // Move from upper right to lower left
                initialPosition = CGPoint(x: size.width, y: size.height)
                velocity = CGVector(dx: -200, dy: -200)
            }
            
            meteor.position = initialPosition
            meteor.physicsBody = SKPhysicsBody(circleOfRadius: meteor.size.width / 2)
            meteor.physicsBody?.categoryBitMask = 2
            meteor.physicsBody?.contactTestBitMask = 1 // Contact with astronaut
            meteor.physicsBody?.collisionBitMask = 0
            meteor.physicsBody?.velocity = velocity
            
            meteorCount += 1
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        // Handle collision
        if contact.bodyA.categoryBitMask == 1 || contact.bodyB.categoryBitMask == 1 {
            // Astronaut collided with meteor
            let losingScene = LosingScene(size: self.size)
            losingScene.scaleMode = self.scaleMode
            let transition = SKTransition.fade(withDuration: 0.5)
            self.view?.presentScene(losingScene, transition: transition)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Update meteor scale based on its position
        for node in children where node.name == "meteor" {
            if let meteor = node as? SKSpriteNode {
                let scale = CGFloat((size.height - meteor.position.y) / size.height) * 2.0 // Adjust scale factor as needed
                meteor.setScale(scale)
            }
        }
    }
}






