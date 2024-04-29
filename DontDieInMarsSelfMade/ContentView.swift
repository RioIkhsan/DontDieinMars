//
//  ContentView.swift
//  DontDieInMarsSelfMade
//
//  Created by Tania Cresentia on 25/04/24.
//

import SwiftUI
import SpriteKit

class StartScene: SKScene {
    
    private var ufo = SKTexture(imageNamed: "ufo")
    private var ufoLight = SKTexture(imageNamed: "ufo-light")
    private var light = SKSpriteNode(imageNamed: "yellow-light")
    private var ufo2 = SKTexture(imageNamed: "ufo2")
    private var ufo3 = SKTexture(imageNamed: "ufo3")
    private var ufo4 = SKTexture(imageNamed: "ufo4")
    private var ufo5 = SKTexture(imageNamed: "ufo5")
    private var ufo6 = SKTexture(imageNamed: "ufo6")
    private var ufo7 = SKTexture(imageNamed: "ufo7")
    private var ufo8 = SKTexture(imageNamed: "ufo8")
                                      
    override func didMove(to view: SKView) {
        self.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        scene?.scaleMode = .aspectFill
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let startNode = atPoint(location)
            
            if startNode.name == "ufo" {
                startNode.run(SKAction.scale(by: 5.0, duration: 3))
                startNode.run(SKAction.moveBy(x: 0, y: -200, duration: 3))
                
                startNode.run(SKAction.animate(with: [ufo, ufoLight], timePerFrame: 0.1, resize: true, restore: false))
                
                startNode.run(SKAction.sequence([
                    SKAction.animate(with: [ufo, ufoLight], timePerFrame: 0.1, resize: true, restore: false),
                    
                    SKAction.wait(forDuration: 5),
                                                 
                    SKAction.animate(with:[ufo2, ufo3, ufo4, ufo5, ufo6, ufo7, ufoLight, ufo8, ufoLight, ufo8, ufoLight, ufo8], timePerFrame: 0.5, resize: true, restore: false),
                    SKAction.removeFromParent()
                ]))
            }
            
            
                if startNode.name == "mars" {
                    let game = GameScene(size: self.size)
                    let transition = SKTransition.fade(withDuration: 3)
                    self.view?.presentScene(game, transition: transition)
                }
            
//                let game = GameScene(size: self.size)
//                let transition = SKTransition.fade(with: .black, duration: 3)
//
//                self.view?.presentScene(game, transition: transition)
        }
    }
}

//Switch to another scene when game finishes

//    func endGame() {
//        let transition = SKTransition.flipHorizontal(withDuration: 1.0)
//        let GameScene = SKScene(fileNamed: "GameScene") as! GameScene
//        
//        GameScene.scaleMode = .aspectFill
//        view!.presentScene(GameScene, transition: transition)
//    }

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
