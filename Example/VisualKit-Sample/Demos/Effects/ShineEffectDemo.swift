//
//  ShineEffectDemo.swift
//  VisualKit-Sample
//
//  Created by Michel-André Chirita on 22/09/2024.
//

import SwiftUI
import VisualKit

struct ShineEffectDemo: View {
    var body: some View {
        VStack {
            Spacer()

            Circle()
                .fill(.clear)
                .frame(width: 100)
                .shineEffect(shape: .circle, borderWidth: 5)
                .frame(height: 350)
            
            Spacer()

            ShineEffect(content: RoundedRectangle(cornerRadius: 40), borderWidth: 3)
                .frame(height: 250)

            Spacer()
        }
        .padding()
        .navigationTitle("ShineEffect")
    }
}

#Preview {
    ShineEffectDemo()
}
