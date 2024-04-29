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
                                      
    override func didMove(to view: SKView) {
        self.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        scene?.scaleMode = .aspectFill
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            for touch in touches {
                let location = touch.location(in: self)
                let startNode = atPoint(location)
                
                if startNode.name == "ufo" {
                    
                    let game = GameScene(size: self.size)
                    let transition = SKTransition.fade(with: .black, duration: 3)
                    
                    self.view?.presentScene(game, transition: transition)
                }
            }
        }
}

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
