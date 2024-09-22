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

            RoundedRectangle(cornerRadius: 30)
                .fill(.blue)

            Spacer()
        }
        .padding()
        .navigationTitle("RaysEffect")
    }
}

#Preview {
    RaysEffectDemo()
}
