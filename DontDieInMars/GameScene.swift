//
//  GameScene.swift
//  DontDieInMarsSelfMade
//
//  Created by Tania Cresentia on 25/04/24.
//

import CoreMotion
import SpriteKit

class GameScene: SKScene {
    
    let background = SKSpriteNode(imageNamed: "full-of-dust")
    let clean = SKSpriteNode(imageNamed: "clean-of-dust")
    
    private var motionManager: CMMotionManager!
        private var lastShakeTime: Date?
        private let shakeCooldown: TimeInterval = 1.0 // Cooldown interval in seconds

        override func didMove(to view: SKView) {
            // Setup motion manager to handle accelerometer updates
            
            backgroundColor = .blue
            background.position = CGPoint(x: size.width/2, y: size.height/2)
            background.zPosition = 1
            addChild(background)
            
            motionManager = CMMotionManager()
            motionManager.accelerometerUpdateInterval = 0.2 // Update interval in seconds
            motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { accelerometerData, error in
                guard let acceleration = accelerometerData?.acceleration else { return }
                self.handleAccelerometerData(acceleration)
            }
        }

        private func handleAccelerometerData(_ acceleration: CMAcceleration) {
            // Calculate magnitude of acceleration
            let magnitude = sqrt(pow(acceleration.x, 2) + pow(acceleration.y, 2) + pow(acceleration.z, 2))

            // Define threshold value to detect shake gesture
            let threshold: Double = 1.5

            // Check if magnitude exceeds threshold to detect shake gesture
            if magnitude > threshold {
                // Check if cooldown period has passed since last shake gesture
                if let lastShakeTime = self.lastShakeTime {
                    let currentTime = Date()
                    let timeSinceLastShake = currentTime.timeIntervalSince(lastShakeTime)
                    
                    if timeSinceLastShake > shakeCooldown {
                        // Shake gesture detected and cooldown period passed
                        self.handleShakeGesture()
                        self.lastShakeTime = currentTime // Update last shake time
                    }
                } else {
                    // First shake gesture detected
                    self.handleShakeGesture()
                    self.lastShakeTime = Date()
                }
            }
        }

        private func handleShakeGesture() {
            // Handle shake gesture here
            print("Shake gesture detected!")
            backgroundColor = .red
            clean.position = CGPoint(x: size.width/2, y: size.height/2)
            clean.zPosition = 2
            addChild(clean)
        }

        override func willMove(from view: SKView) {
            // Stop accelerometer updates when scene is about to move from view
            motionManager.stopAccelerometerUpdates()
        }
    
//    private var motionManager: CMMotionManager!
//    let background = SKSpriteNode(imageNamed: "full-of-dust")
//    let clean = SKSpriteNode(imageNamed: "clean-of-dust")
//
//        override func didMove(to view: SKView) {
//            // Setup motion manager to handle accelerometer updates
//            backgroundColor = .blue
//            addChild(background)
//            motionManager = CMMotionManager()
//            motionManager.accelerometerUpdateInterval = 0.2 // Update interval in seconds
//            motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { accelerometerData, error in
//                guard let acceleration = accelerometerData?.acceleration else { return }
//                self.handleAccelerometerData(acceleration)
//            }
//        }
//
//        private func handleAccelerometerData(_ acceleration: CMAcceleration) {
//            // Calculate magnitude of acceleration
//            let magnitude = sqrt(pow(acceleration.x, 2) + pow(acceleration.y, 2) + pow(acceleration.z, 2))
//
//            // Define threshold value to detect shake gesture
//            let threshold: Double = 1.5
//
//            // Check if magnitude exceeds threshold to detect shake gesture
//            if magnitude > threshold {
//                // Shake gesture detected, handle accordingly
//                self.handleShakeGesture()
//            }
//        }
//
//        private func handleShakeGesture() {
//            // Handle shake gesture here
//            print("Shake gesture detected!")
//            backgroundColor = .red
//        }
//
//        override func willMove(from view: SKView) {
//            // Stop accelerometer updates when scene is about to move from view
//            motionManager.stopAccelerometerUpdates()
//        }
    
}
