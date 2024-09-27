//
//  RaysEffectDemo.swift
//  VisualKit-Sample
//
//  Created by Michel-André Chirita on 22/09/2024.
//

import SwiftUI
import VisualKit

struct RaysEffectDemo: View {
    var body: some View {
        VStack {
            Spacer()

            Circle()
                .fill(.red)
                .frame(width: 250)
                .raysEffect()

            Spacer()
        }
        .padding()
        .navigationTitle("RaysEffect")
    }
}

#Preview {
    RaysEffectDemo()
}
