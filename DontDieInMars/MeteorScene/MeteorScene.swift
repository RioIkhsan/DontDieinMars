//
//  MeteorScene.swift
//  DontDieInMars
//
//  Created by Tania Cresentia on 29/04/24.
//

import Foundation
import SpriteKit
import CoreMotion
import AVFoundation

class MeteorScene: SKScene {
    
    let background = SKSpriteNode(imageNamed: "background-red")
    let meteor = SKSpriteNode(imageNamed: "meteor")
    
    override func didMove(to view: SKView) {
        backgroundColor = .blue
        
        addBackground()
        addMeteor()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if background.contains(location) {
                
                let game = MeteorStartScene(size: self.size)
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
    
    func addMeteor() {
        meteor.position = CGPoint(x: size.width, y: size.height)
        meteor.zPosition = 2
        meteor.setScale(0.3)
        
        let fallAction = SKAction.move(to: CGPoint(x: -50, y: -50), duration: 5.0)
        let scaleAction = SKAction.scale(by: 5.0, duration: 5.0)
        
        meteor.run(fallAction)
        meteor.run(scaleAction)
        addChild(meteor)
    }
    
}



class MeteorStartScene: SKScene {
    
    let background = SKSpriteNode(imageNamed: "meteor-transition-page")
    
    var backgroundMusicPlayer: AVAudioPlayer!
    
    override func didMove(to view: SKView) {
        
        addBackground()
        setUpBgm()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if background.contains(location) {
                
                let game = MeteorGameScene(size: self.size)
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
    
    //    Function to play audio with delay
        func playAudioWithDelay(delay: TimeInterval) {
            // Calculate the time to play audio
            let delayTime = CACurrentMediaTime() + delay
            // Schedule playback with the calculated time
            backgroundMusicPlayer?.play(atTime: delayTime)
        }
    
    func setUpBgm(){
        if let musicURL = Bundle.main.url(forResource: "meteor-announcement", withExtension: "mp3") {
            print("masuk if {}")
            do {
                backgroundMusicPlayer = try AVAudioPlayer(contentsOf: musicURL)
                backgroundMusicPlayer.numberOfLoops = -1 // Loop indefinitely
                
                //                    backgroundMusicPlayer.play()
                playAudioWithDelay(delay: 2.0)
                print("masuk do {}")
            } catch {
                print("Error loading background music: \(error)")
            }
        } else {
            print("ga masuk if {}")
        }
    }
}



class MeteorGameScene: SKScene, SKPhysicsContactDelegate {
    
    var motionManager = CMMotionManager()
    
    let background = SKSpriteNode(imageNamed: "background")
    
    let astronaut = SKSpriteNode(imageNamed: "astronaut-back")
    let meteor = SKSpriteNode(imageNamed: "meteor")
    
    var scoreLabel: SKLabelNode!
    var accelerometer = false
    var startMeteorCreating = false
    var gameFinished = false
    
    var destX: CGFloat = 0.0
    var meteorCount = 0
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        motionManager.startAccelerometerUpdates()
        
        addBackground()
        //        loadOxygenTextures()
        addAstronaut()
        startSpawningMeteors()
        
        accelerometer = true
    }
    
    func startSpawningMeteors() {
        let spawnAction = SKAction.run { [weak self] in
            self?.spawnMeteor()
        }
        let delayAction = SKAction.wait(forDuration: 8.0) // Adjust spawn interval as needed
        let spawnSequence = SKAction.sequence([spawnAction, delayAction])
        let spawnForever = SKAction.repeatForever(spawnSequence)
        run(spawnForever)
    }
    
    func spawnMeteor() {
        if meteorCount < 5 {
            let meteor = SKSpriteNode(imageNamed: "meteor")
            meteor.name = "meteor" // Set name for identification in the update loop
            meteor.zPosition = 3
            addChild(meteor)
            
            // Set meteor's initial position and physics properties
            var initialPosition = CGPoint()
            var velocity = CGVector()
            if meteorCount % 2 != 0 {
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
            meteor.physicsBody?.affectedByGravity = false
            meteor.physicsBody?.categoryBitMask = 2
            meteor.physicsBody?.contactTestBitMask = 1 // Contact with astronaut
            meteor.physicsBody?.collisionBitMask = 0
            meteor.physicsBody?.velocity = velocity
            
        }
        meteorCount += 1
    }
    
    override func update(_ currentTime: TimeInterval) {
        moveX()
        astronaut.run(SKAction.moveTo(x: destX, duration: 1))
        sideConstraints()
        
        // Update meteor scale based on its position
        for node in children where node.name == "meteor" {
            if let meteor = node as? SKSpriteNode {
                let scale = CGFloat((size.height - meteor.position.y) / size.height) * 3.5 // Adjust scale factor as needed
                meteor.setScale(scale)
            }
        }
        
        if meteorCount > 5 {
            motionManager.stopAccelerometerUpdates()
            
            let winningScene = WinningScene2(size: self.size)
            winningScene.scaleMode = self.scaleMode
            let transition = SKTransition.fade(withDuration: 0.5)
            self.view?.presentScene(winningScene, transition: transition)
        }
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        // Handle collision
        if contact.bodyA.categoryBitMask == 1 || contact.bodyB.categoryBitMask == 1 {
            // Astronaut collided with meteor
            
            astronaut.texture = SKTexture(imageNamed: "astronaut-back-dead")
            
            let losingScene = MeteorLosingScene(size: self.size)
            losingScene.scaleMode = self.scaleMode
            let transition = SKTransition.fade(withDuration: 3.0)
            self.view?.presentScene(losingScene, transition: transition)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // no touches from user?
    }
    
    func addBackground() {
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = 1
        addChild(background)
    }
    
    func addAstronaut() {
        astronaut.position = CGPoint(x: size.width/2, y: size.height/6)
        astronaut.setScale(0.5)
        astronaut.zPosition = 3
        
        addChild(astronaut)
        
        //set up physics bodies
        astronaut.physicsBody = SKPhysicsBody(circleOfRadius: astronaut.size.width / 2.5)
        astronaut.physicsBody?.isDynamic = false // Fixed on the ground
        astronaut.physicsBody?.categoryBitMask = 1
        astronaut.physicsBody?.collisionBitMask = 0
    }
    
    // moving astronaut at X axis
    func moveX() {
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.1
            motionManager.startAccelerometerUpdates(to: .main) {
                (data, error) in
                guard let data = data, error == nil else {
                    return
                }
                
                let currentX = self.astronaut.position.x
                self.destX = currentX + CGFloat(data.acceleration.x * 300)
                //buat lebih berat?
            }
        }
    }
    
    // setting limits of game area on the sides
    func sideConstraints() {
        let rightConstraint = size.width/2 + 200
        let leftConstraint = rightConstraint*(-1)
        let positionX = astronaut.position.x
        
        if (positionX > rightConstraint) {
            astronaut.run(SKAction.moveTo(x: rightConstraint, duration: 0.1))
            if destX < rightConstraint {
                astronaut.run(SKAction.moveTo(x: destX, duration: 1))
            }
        }
        
        if (positionX < leftConstraint) {
            astronaut.run(SKAction.moveTo(x: leftConstraint, duration: 0.1))
            if destX > leftConstraint {
                astronaut.run(SKAction.moveTo(x: destX, duration: 1))
            }
        }
    }
    
    //Design and physic properties of meteor
    
    func createMeteor() { // unused but is actually good
        
        meteor.position = CGPoint(x: size.width, y: size.height)
        meteor.zPosition = 3
        addChild(meteor)
        
        // set up physics bodies
        meteor.physicsBody = SKPhysicsBody(circleOfRadius: meteor.size.width / 8)
        meteor.physicsBody?.categoryBitMask = 2
        meteor.physicsBody?.contactTestBitMask = 1 // Contact with astronaut
        meteor.physicsBody?.collisionBitMask = 0
        
        //apply velocity to the meteor
        let diagonalVector = CGVector(dx: -10, dy: -10) // Adjust speed as needed
        meteor.physicsBody?.velocity = diagonalVector
        
    }
    
}


class MeteorLosingScene: SKScene {
    
    let background = SKSpriteNode(imageNamed: "background")
    let astronaut = SKSpriteNode(imageNamed: "astronaut-back-dead")
    let ghost = SKSpriteNode(imageNamed: "ghost")
    
    override func didMove(to view: SKView) {
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = 1
        addChild(background)
        
        astronaut.position = CGPoint(x: size.width/2, y: size.height/3)
        astronaut.setScale(1.0)
        astronaut.zPosition = 2
        addChild(astronaut)
        
        ghost.size = CGSize(width: 200, height: 200)
        ghost.position = CGPoint(x: size.width / 2, y: 0)
        ghost.zPosition = 3
        ghost.alpha = 0
        addChild(ghost)
        
        let waitAction = SKAction.wait(forDuration: 0.5)
        let fadeInAction = SKAction.fadeIn(withDuration: 0.5)
        let moveAction = SKAction.move(to: CGPoint(x: size.width / 2, y: size.height*1.5), duration: 3)
        let fadeOutAction = SKAction.fadeOut(withDuration: 1)
        let groupAction = SKAction.group([fadeInAction, moveAction])
        let fullSequence = SKAction.sequence([waitAction, groupAction ,fadeOutAction])
        
        ghost.run(fullSequence)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if astronaut.contains(location) {
                let game = MeteorScene(size: self.size)
                let transition = SKTransition.fade(with: .black, duration: 3)
                
                self.view?.presentScene(game, transition: transition)
            }
        }
    }
}


class MeteorGameSceneUpDown: SKScene, SKPhysicsContactDelegate {
    
    var motionManager = CMMotionManager()
    
    let background = SKSpriteNode(imageNamed: "background")
    
    let astronaut = SKSpriteNode(imageNamed: "astronaut-back")
    let meteor = SKSpriteNode(imageNamed: "meteor")
    
    var scoreLabel: SKLabelNode!
    var accelerometer = false
    var startMeteorCreating = false
    var gameFinished = false
    
    var destY: CGFloat = 0.0
    var meteorCount = 0
    
    var initialAstronautPosition: CGPoint = .zero
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        motionManager.startAccelerometerUpdates()
        
        addBackground()
        addAstronaut()
        startSpawningMeteors()
        print("spawned meteor")
        
        accelerometer = true
        
        // Record the initial position of the astronaut
//        initialAstronautPosition = astronaut.position
        initialAstronautPosition = CGPoint(x: size.width/2, y: size.height/4)
        
    }
    
    func startSpawningMeteors() {
        let spawnAction = SKAction.run { [weak self] in
            self?.spawnMeteor()
        }
        let delayAction = SKAction.wait(forDuration: 10.0) // Adjust spawn interval as needed
        let spawnSequence = SKAction.sequence([spawnAction, delayAction])
        let spawnForever = SKAction.repeatForever(spawnSequence)
        run(spawnForever)
    }
    
    func spawnMeteor() {
        if meteorCount < 5 {
            let meteor = SKSpriteNode(imageNamed: "meteor")
            meteor.name = "meteor" // Set name for identification in the update loop
            meteor.zPosition = 3
            addChild(meteor)
            
            // Set meteor's initial position and physics properties
            var initialPosition = CGPoint()
            var velocity = CGVector()
            if meteorCount % 2 == 0 {
                // Move from upper left to lower right
                initialPosition = CGPoint(x: 0, y: size.height*4/5)
                velocity = CGVector(dx: 200, dy: -20)
            } else {
                // Move from upper right to lower left
                initialPosition = CGPoint(x: size.width, y: size.height*4/5)
                velocity = CGVector(dx: -200, dy: -20)
            }
            
            meteor.position = initialPosition
            meteor.setScale(0.8)
            meteor.physicsBody = SKPhysicsBody(circleOfRadius: meteor.size.width / 2)
            meteor.physicsBody?.affectedByGravity = false
            meteor.physicsBody?.categoryBitMask = 2
            meteor.physicsBody?.contactTestBitMask = 1 // Contact with astronaut
            meteor.physicsBody?.collisionBitMask = 0
            meteor.physicsBody?.velocity = velocity
            
        }
        meteorCount += 1
    }
    
    override func update(_ currentTime: TimeInterval) {
        moveY()
        astronaut.run(SKAction.moveTo(y: destY, duration: 1))
        sideConstraints()
        
        initialAstronautPosition = CGPoint(x: size.width/2, y: size.height/4)
        
//        // Check if any meteor is outside the screen bounds
//            for node in children where node.name == "meteor" {
//                if let meteor = node as? SKSpriteNode {
//                    if meteor.position.y < 0 || meteor.position.y > size.height || meteor.position.x < 0 || meteor.position.x > size.width {
//                        // Move the astronaut back to the initial position
//                        let moveBackAction = SKAction.move(to: initialAstronautPosition, duration: 0.5)
//                        astronaut.run(moveBackAction)
//                        break // Exit the loop once a meteor is found outside the screen
//                    }
//                }
//            }
        
        // Update meteor scale based on its position
        //        for node in children where node.name == "meteor" {
        //            if let meteor = node as? SKSpriteNode {
        //                let scale = CGFloat((size.height - meteor.position.y) / size.height) * 1.5 // Adjust scale factor as needed
        //                meteor.setScale(scale)
        //            }
        //        }
        
        if meteorCount > 5 {
            motionManager.stopAccelerometerUpdates()
            
            let winningScene = WinningScene2(size: self.size)
            winningScene.scaleMode = self.scaleMode
            let transition = SKTransition.fade(withDuration: 0.5)
            self.view?.presentScene(winningScene, transition: transition)
        }
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        // Handle collision
        
        if contact.bodyA.categoryBitMask == 1 || contact.bodyB.categoryBitMask == 1 {
            // Astronaut collided with meteor
            astronaut.texture = SKTexture(imageNamed: "astronaut-back-dead")
            
//            let losingScene = MeteorLosingScene(size: self.size)
//            losingScene.scaleMode = self.scaleMode
//            let transition = SKTransition.fade(withDuration: 3.0)
//            self.view?.presentScene(losingScene, transition: transition)
            
        } else {
            // No collision with meteor
            // Move astronaut back to initial position after a delay
//            let moveBackAction = SKAction.move(to: initialAstronautPosition, duration: 0.5)
            let moveBackAction = SKAction.move(to: CGPoint(x: size.width/2, y: size.height/4), duration: 0.5)
            astronaut.run(SKAction.sequence([moveBackAction, SKAction.wait(forDuration: 2.0)]))
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // no touches from user?
    }
    
    func addBackground() {
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = 1
        addChild(background)
    }
    
    func addAstronaut() {
        astronaut.position = CGPoint(x: size.width/2, y: size.height/4)
        astronaut.setScale(0.5)
        astronaut.zPosition = 3
        
        addChild(astronaut)
        
        //set up physics bodies
        astronaut.physicsBody = SKPhysicsBody(circleOfRadius: astronaut.size.width / 2)
        astronaut.physicsBody?.isDynamic = false // Fixed on the ground
        astronaut.physicsBody?.affectedByGravity = false
        astronaut.physicsBody?.categoryBitMask = 1
        astronaut.physicsBody?.collisionBitMask = 0
    }
    
    // moving astronaut at Y axis
    func moveY() {
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.01
            motionManager.startAccelerometerUpdates(to: .main) {
                (data, error) in
                guard let data = data, error == nil else {
                    return
                }
                
                let currentY = self.astronaut.position.y
                self.destY = currentY + CGFloat(data.acceleration.y * 500)
                //buat lebih berat?
            }
        }
    }
    
    // setting limits of game area on the sides
    func sideConstraints() {
        let upperConstraint = size.height * 0.1
        let lowerConstraint = 0.0 //size.height * -0.1
        let positionY = astronaut.position.y
        
        if (positionY > upperConstraint) {
            astronaut.run(SKAction.moveTo(y: upperConstraint, duration: 0.1))
            if destY < upperConstraint {
                astronaut.run(SKAction.moveTo(y: destY, duration: 1))
            }
        }
        
        if (positionY < lowerConstraint) {
            astronaut.run(SKAction.moveTo(y: lowerConstraint, duration: 0.1))
            if destY > lowerConstraint {
                astronaut.run(SKAction.moveTo(y: destY, duration: 1))
            }
        }
    }
    
    
}
