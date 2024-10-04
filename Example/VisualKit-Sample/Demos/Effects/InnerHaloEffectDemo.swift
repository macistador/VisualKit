//
//  InnerHaloEffectView.swift
//  VisualKit-Sample
//
//  Created by Michel-André Chirita on 01/10/2024.
//

import SwiftUI
import VisualKit

struct InnerHaloEffectDemo: View {
    
    @State var effectTrigger: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            Button {
                effectTrigger = true
            } label: {
                Text("Shoot")
            }
            .buttonStyle(.borderedProminent)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .navigationTitle("InneHaloEffect")
        .innerHaloEffect(trigger: $effectTrigger, color: .meshGradient([
            .pink, .pink,
            .yellow, .pink,
            .purple, .pink,
            .purple, .cyan,
            .purple, .purple
        ]))
    }
}

#Preview {
    InnerHaloEffectDemo()
}
