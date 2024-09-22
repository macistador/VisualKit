//
//  SwiftUIView.swift
//  VisualKit
//
//  Created by Michel-André Chirita on 22/09/2024.
//

import SwiftUI

public struct RaysEffectModifier: ViewModifier {
    
//    enum ShapeKind {
//        case rectangle(radius: Double)
//        case circle
//    }
//
//    let shape: ShapeKind
    @State private var didAppear = false

    public func body(content: Content) -> some View {
        content
            .overlay(alignment: .center) {
                RoundedRectangle(cornerRadius: 3)
                    .fill(.white)
                    .frame(width: 100, height: 4)
                    .scaleEffect(x: 0.1, y: 0.3)
                    .rotationEffect(.degrees(30), anchor: .center)
                    .offset(x: 0, y: 0)
            }
            .onAppear {
                withAnimation(.linear(duration: 1.0).repeatForever()) {
                    didAppear = true
                }
            }
    }
}

public extension View {
    func raysEffect() -> some View {
        modifier(RaysEffectModifier())
    }
}

private struct DemoRaysEffectView: View {
    var body: some View {
        VStack {
            Spacer()
            
            Circle()
                .fill(.red)
                .frame(width: 150)
                .raysEffect()
            
            Spacer()
        }
    }
}

#Preview {
    DemoRaysEffectView()
}
