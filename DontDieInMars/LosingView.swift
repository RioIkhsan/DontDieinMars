//
//  LosingView.swift
//  DontDieInMars
//
//  Created by Rio Ikhsan on 29/04/24.
//

import SwiftUI
import Lottie

struct LosingView: View {
    var body: some View {
        ZStack{
            
            Image("background-dust")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        
            
            LottieView(fileName: "meteor-death", loopMode: .playOnce, speed: 0.75)
        
        }

    }
}

#Preview {
    LosingView()
}
