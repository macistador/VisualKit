//
//  BrushViewDemo.swift
//  VisualKit-Sample
//
//  Created by Michel-André Chirita on 22/09/2024.
//

import SwiftUI
import VisualKit

struct BrushViewDemo: View {
    
    @State var offsetWidth: Double = 5
    
    var body: some View {
        VStack {
            Spacer()
            
            BrushView(offsetWidth: $offsetWidth)
                .frame(height: 100)
                        
            Stepper("Width", onIncrement: {
                offsetWidth += 30
            }, onDecrement: {
                offsetWidth -= 30
            })
            .frame(width: 200)
            
            Spacer()
        }
        .navigationTitle("BrushView")
        .padding()
    }
}

#Preview {
    BrushViewDemo()
}
