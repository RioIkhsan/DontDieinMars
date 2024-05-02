//
//  GameScene.swift
//  DontDieInMarsSelfMade
//
//  Created by Tania Cresentia on 25/04/24.

import CoreMotion
import SpriteKit
import CoreHaptics
import AVFoundation

class GameScene: SKScene {
    
    let background = SKSpriteNode(imageNamed: "full-of-dust")
    let scene1 = SKSpriteNode(imageNamed: "scene 1")
    let scene2 = SKSpriteNode(imageNamed: "scene 2")
    let scene3 = SKSpriteNode(imageNamed: "scene 3")
    let scene4 = SKSpriteNode(imageNamed: "scene 4")
    let scene5 = SKSpriteNode(imageNamed: "scene 5")
    let clean = SKSpriteNode(imageNamed: "clean-of-dust")
    var oxygenTank = SKSpriteNode(imageNamed: "oxygen-tank-0")
    
    var oxygenTankTextures: [SKTexture] = []
    var hapticEngine: CHHapticEngine!
    
    
    private var motionManager: CMMotionManager!
    private var lastShakeTime: Date?
    private let shakeCooldown: TimeInterval = 0.5 // Cooldown interval in seconds
    private var shakeCount = 0
    private var maxShake = 5
    private var isShakeAllowed = true
    private var gameStartTime: TimeInterval = 0.0
    
    private var unshakenTimeLimit: TimeInterval = 18.0
    
    var backgroundMusicPlayer: AVAudioPlayer!
    
    override func didMove(to view: SKView) {
        
        setUpBgm()
        
        
        //        do {
        //            hapticEngine = try CHHapticEngine()
        //            try hapticEngine.start()
        //        } catch {
        //            print("Error starting haptic engine: \(error)")
        //        }
        
        super.didMove(to: view)
        
        //            // Memulai haptic feedback
        //            if let continuousEvent = createContinuousHapticEvent() {
        //                do {
        //                    let pattern = try CHHapticPattern(events: [continuousEvent], parameters: [])
        //                    let player = try hapticEngine.makePlayer(with: pattern)
        //                    try player.start(atTime: CHHapticTimeImmediate)
        //                } catch {
        //                    print("Error playing haptic pattern: \(error)")
        //                }
        //            }
        //
        //            // Atur durasi haptic sesuai dengan durasi scene
        //            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
        //                // Hentikan haptic feedback
        //                self.hapticEngine.stop(completionHandler: nil)
        //            }
        // Setup motion manager to handle accelerometer updates
        
        setupHapticEngine()
        startHapticFeedback()
        
        print("scene 1")
        addBackground1()
        loadOxygenTextures()
        
        gameStartTime = CACurrentMediaTime()
        
        motionManager = CMMotionManager()
        motionManager.accelerometerUpdateInterval = 0.2 // Update interval in seconds
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { accelerometerData, error in
            guard let acceleration = accelerometerData?.acceleration else { return }
            self.handleAccelerometerData(acceleration)
        }
    }
    
//    Function to play audio with delay
    func playAudioWithDelay(delay: TimeInterval) {
        // Calculate the time to play audio
        let delayTime = CACurrentMediaTime() + delay
        // Schedule playback with the calculated time
        backgroundMusicPlayer?.play(atTime: delayTime)
    }
    
    func setUpBgm(){
        if let musicURL = Bundle.main.url(forResource: "heartbeat-12sec", withExtension: "mp3") {
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
    
    func createContinuousHapticEvent() -> CHHapticEvent? {
        do {
            // Membuat pattern intensitas haptic
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 5)
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 5)
            
            // Membuat event haptic
            let event = try CHHapticEvent(eventType: .hapticContinuous, parameters: [intensity, sharpness], relativeTime: 0, duration: 9999)
            
            return event
        } catch {
            print("Error creating haptic event: \(error)")
            return nil
        }
    }
    
    func setupHapticEngine() {
        do {
            hapticEngine = try CHHapticEngine()
            try! hapticEngine?.start()
            print("Haptic berjalan")
        } catch {
            print("Error starting haptic engine: \(error)")
        }
    }
    
    func startHapticFeedback() {
        guard let engine = hapticEngine else { return }
        
        if let continuousEvent = createContinuousHapticEvent() {
            do {
                let pattern = try CHHapticPattern(events: [continuousEvent], parameters: [])
                let player = try engine.makePlayer(with: pattern)
                try player.start(atTime: 0)
            } catch {
                print("Error playing haptic pattern: \(error)")
            }
        }
        
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 9999) {
        //            self.hapticEngine?.stop(completionHandler: nil)
        //        }
    }
    
    func addBackground1() {
        if background.parent != nil {
                background.removeFromParent()
            }
        scene1.position = CGPoint(x: size.width/2, y: size.height/2)
        scene1.zPosition = 1
        addChild(scene1)
    }
    
    func addBackground2() {
        if background.parent != nil {
                background.removeFromParent()
            }
        scene2.position = CGPoint(x: size.width/2, y: size.height/2)
        scene2.zPosition = 1
        addChild(scene2)
    }
    
    func addBackground3() {
        if background.parent != nil {
                background.removeFromParent()
            }
        scene3.position = CGPoint(x: size.width/2, y: size.height/2)
        scene3.zPosition = 1
        addChild(scene3)
    }
    
    func addBackground4() {
        if background.parent != nil {
                background.removeFromParent()
            }
        scene4.position = CGPoint(x: size.width/2, y: size.height/2)
        scene4.zPosition = 1
        addChild(scene4)
    }
    
    func addBackground5() {
        if background.parent != nil {
                background.removeFromParent()
            }
        scene5.position = CGPoint(x: size.width/2, y: size.height/2)
        scene5.zPosition = 1
        addChild(scene5)
    }
    
    func loadOxygenTextures() {
        for i in 0...9 {
            let texture = SKTexture(imageNamed: "oxygen-tank-\(i)")
            oxygenTankTextures.append(texture)
        }
        
        oxygenTank = SKSpriteNode(texture: oxygenTankTextures[0])
        oxygenTank.position = CGPoint(x: size.width/2, y: size.height*8/9)
        oxygenTank.zPosition = 3
        addChild(oxygenTank)
        
        let animateOxygenTank = SKAction.animate(with: oxygenTankTextures, timePerFrame: 1.2)
        
        //        let repeatAction = SKAction.repeatForever(animateOxygenTank)
        
        //      oxygenTank.run(repeatAction)
        oxygenTank.run(animateOxygenTank)
        
    }
    
    func handleAccelerometerData(_ acceleration: CMAcceleration) {
        guard isShakeAllowed else {
            return
        }
        
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
    
    func handleShakeGesture() {
        // Handle shake gesture here
        self.hapticEngine?.stop(completionHandler: nil)
        print("Shake gesture detected!")
        isShakeAllowed = false
        clean.isHidden = false
        //        oxygenTank.removeFromParent()
        
        clean.position = CGPoint(x: size.width/2, y: size.height/2)
        clean.zPosition = 2
        addChild(clean)
        //        loadOxygenTextures()
        
        shakeCount = shakeCount + 1
        
        
        
        if shakeCount < maxShake {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                switch self.shakeCount {
                case 1:
                    print("Scene 2")
                    self.addBackground2()
                case 2:
                    print("Scene 3")
                    self.addBackground3()
                case 3:
                    print("Scene 4")
                    self.addBackground4()
                case 4:
                    print("Scene 5")
                    self.addBackground5()
                default:
                    print("scene 1")
                    self.addBackground1()
                }
                
                self.clean.isHidden = true
                
                self.clean.removeFromParent()
                self.isShakeAllowed = true
                self.setupHapticEngine()
                self.startHapticFeedback()
                //                self.hapticEngine = nil
            }
        } else {
            motionManager.stopAccelerometerUpdates()
            
            moveToWinningScene()
        }
    }
    
    override func willMove(from view: SKView) {
        // Stop accelerometer updates when scene is about to move from view
        motionManager.stopAccelerometerUpdates()
        super.willMove(from: view)
        
        // Pastikan untuk menghentikan engine haptic saat scene berpindah
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        // For initial no shake detection
        //        if self.lastShakeTime == nil {
        //            self.lastShakeTime = Date()
        //        }
        // Check if 10 seconds have passed without shake
        //        if let lastShakeTime = self.lastShakeTime {
        //            let currentTime = Date()
        //            let timeSinceLastShake = currentTime.timeIntervalSince(lastShakeTime)
        //            if timeSinceLastShake >= unshakenTimeLimit {
        //                    moveToLosingScene()
        //
        //                }
        //            }
        
        //check if all shake are done within 10 seconds
        let currentTime = CACurrentMediaTime()
        let elapsedTime = currentTime - gameStartTime
        if elapsedTime >= unshakenTimeLimit {
            if shakeCount < maxShake {
                moveToLosingScene()
            }
        }
    }
    
    func moveToWinningScene() {
        let winning = WinningScene1(size: self.size)
        let transition = SKTransition.fade(with: .black, duration: 3)
        
        backgroundMusicPlayer.stop()
        self.view?.presentScene(winning, transition: transition)
    }
    
    func moveToLosingScene() {
        let losing = LosingScene(size: self.size)
        let transition = SKTransition.fade(with: .black, duration: 3)
        
        backgroundMusicPlayer.stop()
        self.view?.presentScene(losing, transition: transition)
    }
    
}
