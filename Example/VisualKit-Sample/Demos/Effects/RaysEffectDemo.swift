//
//  RaysEffectDemo.swift
//  VisualKit-Sample
//
//  Created by Michel-André Chirita on 22/09/2024.
//

import SwiftUI
import VisualKit

struct RaysEffectDemo: View {
    
    @State var effectTrigger: Bool = false
    @State var effectTrigger2: Bool = false

    var body: some View {
        VStack {
            Spacer()
            
            Button {
                effectTrigger = true
            } label: {
                ZStack {
                    Circle()
                        .fill(.red)
                        .frame(width: 100)
                    Text("Shoot")
                        .foregroundStyle(.white)
                }
            }
            .raysEffect(trigger: $effectTrigger)

            Button {
                effectTrigger2 = true
            } label: {
                ZStack {
                    Circle()
                        .fill(.red)
                        .frame(width: 100)
                    Text("Shoot flash")
                        .foregroundStyle(.white)
                }
            }
            .raysEffect(.flash, trigger: $effectTrigger2)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .navigationTitle("RaysEffect")
    }
}

#Preview {
    RaysEffectDemo()
}
