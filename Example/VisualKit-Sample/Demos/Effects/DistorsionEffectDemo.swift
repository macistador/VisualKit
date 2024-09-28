//
//  DistorsionEffectsViewDemo.swift
//  VisualKit-Sample
//
//  Created by Michel-André Chirita on 23/09/2024.
//

import SwiftUI
import VisualKit

struct DistorsionEffectDemo: View {
    
    @State private var snakeColor = Color.white.opacity(0.8)
    @State private var animate = false

    var body: some View {
        ScrollView {
            VStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white)
                    .frame(width: 200, height: 200)
                    .snakeEffect(effectAmplitude: 0.8, effectSpeed: 10)
                    .shadow(color: .blue.opacity(0.3), radius: 10)
                    .frame(height: 200)
                    .padding(.vertical)
                
                Capsule()
                    .fill(snakeColor)
                    .padding(.horizontal, 40)
                    .snakeEffect()
                    .padding(.vertical)
                
                Capsule()
                    .fill(snakeColor)
                    .padding(.horizontal, 40)
                    .snakeEffect(thickness: 10, effectAmplitude: 10, effectSpeed: 2, effectInversedFrequency: 100)
                    .padding(.vertical)
                
                Button {
                    animate.toggle()
                } label: {
                    Text("Toggle")
                        .bold()
                }
                .buttonStyle(.borderedProminent)
                .padding(.top, 40)
                
                Spacer()
                
                ZStack {
                    ForEach(0...17, id: \.self) { id in
                        Capsule()
                            .fill(snakeColor)
                            .scaleEffect(0.5)
                            .snakeEffect(thickness: animate ? 40 : 0, effectAmplitude: 10, effectSpeed: 10, effectInversedFrequency: 50)
                            .offset(x: 100, y: Double(id * 0))
                            .rotationEffect(.degrees(animate ? Double(id * 20) : 0))
                            .animation(.bouncy(duration: 1.0, extraBounce: 0.2), value: animate)
                    }
                }
                .frame(height: 400)
                
                Spacer()
            }
        }
        .background(.gray)
        .navigationTitle("DistortionEffect")
    }
}

#Preview {
    DistorsionEffectDemo()
}
