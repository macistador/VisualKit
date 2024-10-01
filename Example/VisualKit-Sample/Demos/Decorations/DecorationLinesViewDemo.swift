//
//  DecorationLinesViewDemo.swift
//  VisualKit-Sample
//
//  Created by Michel-André Chirita on 01/10/2024.
//

import SwiftUI
import VisualKit

struct DecorationsLinesViewDemo: View {
    var body: some View {
//        DecorationsLinesView()
//            .background(.green)
        
        ZStack {
            Color.orange
            Color.red
                .blendMode(.overlay)
                .mask {
                    RoundedRectangle(cornerRadius: 100)
                        .stroke(lineWidth: 50)
                        .blur(radius: 50)
                        .scaleEffect(1.1)
                }
            Color.clear
                .background(DecorationsLinesView())
        }
        .ignoresSafeArea()
        .navigationTitle("DecorationsLinesView")
    }
}

#Preview {
    DecorationsLinesViewDemo()
}
