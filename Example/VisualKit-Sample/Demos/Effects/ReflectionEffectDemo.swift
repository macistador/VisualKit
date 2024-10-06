//
//  ReflectionEffectDemo.swift
//  VisualKit-Sample
//
//  Created by Michel-André Chirita on 04/10/2024.
//

import SwiftUI
import VisualKit

struct ReflectionEffectDemo: View {
    
    @State var effectTrigger: Bool = false
    @State var effectTrigger2: Bool = false

    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Text("This is a nice text")
                .font(.title)
                .bold()
                .reflectionEffect(trigger: $effectTrigger, color: .red, repeatEffect: .forever(pause: 2)) {
                    Text("This is a nice text")
                        .font(.title)
                        .bold()
                }
                .onAppear { effectTrigger = true }
            
            Button {
                effectTrigger2 = true
            } label: {
                ZStack {
                    Circle()
                        .fill(.red)
                        .frame(width: 100)
                    Text("Shoot")
                        .foregroundStyle(.white)
                }
            }
            .reflectionEffect(trigger: $effectTrigger2,
                              color: .white.opacity(0.5),
                              speedMultiplier: 2,
                              reflectionKind: .triple) {
                Circle()
                    .frame(width: 100)
            }

            Spacer()
        }
        .navigationTitle("ReflectionEffect")
    }
}

#Preview {
    ReflectionEffectDemo()
}
