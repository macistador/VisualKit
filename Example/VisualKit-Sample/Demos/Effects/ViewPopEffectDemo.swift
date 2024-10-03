//
//  TextPopEffectDemo.swift
//  VisualKit-Sample
//
//  Created by Michel-André Chirita on 02/10/2024.
//

import SwiftUI
import VisualKit

struct ViewPopEffectDemo: View {
    
    @State var heartEffectTrigger: Bool = false
    @State var heart2EffectTrigger: Bool = false
    @State var textEffectTrigger: Bool = false

    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            Button {
                heartEffectTrigger = true
            } label: {
                Text("Shoot ❤️")
            }
            .buttonStyle(.borderedProminent)
            .viewPopEffect(text: "❤️", trigger: $heartEffectTrigger, pause: 1)

            Button {
                heart2EffectTrigger = true
            } label: {
                Text("Shoot ❤️")
            }
            .buttonStyle(.borderedProminent)
            .viewPopEffect(trigger: $heart2EffectTrigger,
                           direction: .over(scale: 2)) {
                Text("❤️")
            }
            
            Button {
                textEffectTrigger = true
            } label: {
                Text("Shoot text")
            }
            .buttonStyle(.borderedProminent)
            .viewPopEffect(text: "REACTED !",
                           trigger: $textEffectTrigger,
                           direction: .bottom(offset: 30),
                           font: .custom("WhiteOnBlack", size: 20),
                           intensity: 1.5,
                           pause: 2,
                           rotation: -5)

            Spacer()
        }
        .frame(maxWidth: .infinity)
        .navigationTitle("ViewPopEffect")
    }
}

#Preview {
    ViewPopEffectDemo()
}

