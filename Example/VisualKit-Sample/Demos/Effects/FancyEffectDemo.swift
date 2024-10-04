//
//  FancyEffectDemo.swift
//  VisualKit-Sample
//
//  Created by Michel-André Chirita on 04/10/2024.
//

import SwiftUI
import VisualKit

struct FancyEffectDemo: View {
    
    @State var effectTrigger: Bool = false
    @State var effectTrigger2: Bool = false
    @State var effectTrigger3: Bool = false
    @State var pauseDuration: Double = 0
    @State var pauseEvery: Double = 3

    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Button {
                effectTrigger.toggle()
            } label: {
                ZStack {
                    Capsule()
                        .fill(.red)
                        .frame(width: 200, height: 50)
                    Text("Shake")
                        .foregroundStyle(.white)
                        .bold()
                }
            }
            .fancyEffect(trigger: $effectTrigger, effect: .shake(), repeatEffect: .forever(pause: pauseDuration, pauseEvery: Int(pauseEvery)))
            
            Button {
                effectTrigger2.toggle()
            } label: {
                ZStack {
                    Capsule()
                        .fill(.red)
                        .frame(width: 200, height: 50)
                    Text("Bounce simple")
                        .foregroundStyle(.white)
                        .bold()
                }
            }
            .fancyEffect(trigger: $effectTrigger2, effect: .bounce(asymmetric: false), repeatEffect: .forever(pause: pauseDuration, pauseEvery: Int(pauseEvery)))
            
            Button {
                effectTrigger3.toggle()
            } label: {
                ZStack {
                    Capsule()
                        .fill(.red)
                        .frame(width: 200, height: 50)
                    Text("Bounce asymmetric")
                        .foregroundStyle(.white)
                        .bold()
                }
            }
            .fancyEffect(trigger: $effectTrigger3, effect: .bounce(asymmetric: true), repeatEffect: .forever(pause: pauseDuration, pauseEvery: Int(pauseEvery)))
            
            Spacer()
        
            HStack {
                Text("Pause duration")
                Spacer()
                Slider(value: $pauseDuration, in: (0...10.0), step: 1)
                Text("\(Int(pauseDuration))")
                    .frame(width: 25)
            }

            HStack {
                Text("Pause every")
                Spacer()
                Slider(value: $pauseEvery, in: (1...10.0), step: 1)
                Text("\(Int(pauseEvery))")
                    .frame(width: 25)
            }
            
            Spacer()
        }
    }
}

#Preview {
    FancyEffectDemo()
}
