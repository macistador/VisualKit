//
//  FullScreenTitleEffectDemo.swift
//  VisualKit-Sample
//
//  Created by Michel-André Chirita on 02/10/2024.
//

import SwiftUI
import VisualKit

struct FullScreenTitleEffectDemo: View {
   
    @State var effectTrigger: Bool = false
    @State var effectTrigger2: Bool = false
    @State var effectTrigger3: Bool = false
    @State var effectTrigger4: Bool = false

    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Button {
                effectTrigger = true
            } label: {
                Text("Shoot first")
            }
            .buttonStyle(.borderedProminent)
            
            Button {
                effectTrigger2 = true
            } label: {
                Text("Shoot second")
            }
            .buttonStyle(.borderedProminent)

            Button {
                effectTrigger3 = true
            } label: {
                Text("Shoot third")
            }
            .buttonStyle(.borderedProminent)
            
            Button {
                effectTrigger4 = true
            } label: {
                Text("Shoot fourth")
            }
            .buttonStyle(.borderedProminent)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(.green)
        .navigationTitle("FullScreenTitleEffect")
        .fullScreenTitleEffect(.first(text: "Whaouu!"), trigger: $effectTrigger)
        .fullScreenTitleEffect(.second(text: "WELL DONE!"), trigger: $effectTrigger2)
        .fullScreenTitleEffect(.third(text: "COMPLETED"), trigger: $effectTrigger3)
        .fullScreenTitleEffect(.fourth(text: "DONE", textBorderColor: .pink), trigger: $effectTrigger4)
        .ignoresSafeArea()
    }
}

#Preview {
    FullScreenTitleEffectDemo()
}
