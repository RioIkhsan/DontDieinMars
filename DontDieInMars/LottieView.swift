////
////  LottieView.swift
////  DontDieInMars
////
////  Created by Tania Cresentia on 29/04/24.
////
//
//import SwiftUI
//import Lottie
//import SpriteKit
//
//struct LottieView: UIViewRepresentable {
//    
//    var fileName: String
//    let loopMode: LottieLoopMode
//    let speed: Float
//    
//    func updateUIView(_ uiView: UIViewType, context: Context) {
//        
//    }
//    
//    func makeUIView(context: Context) -> Lottie.LottieAnimationView {
//        let animationView = LottieAnimationView(name: fileName)
//        animationView.loopMode = loopMode
//        animationView.play()
//        animationView.contentMode = .scaleAspectFill
//        animationView.animationSpeed = CGFloat(speed)
//        let animationNode = SKViewNode(viewWithLoader: { () -> UIView in
//            
//        })
//        return animationView
//    }
//}
//
//#Preview {
//    LottieView(fileName: "meteor-animated", loopMode: .loop, speed: 1.0)
//}
