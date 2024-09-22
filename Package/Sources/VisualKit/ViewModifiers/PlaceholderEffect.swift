//
//  SwiftUIView.swift
//  VisualKit
//
//  Created by Michel-André Chirita on 22/09/2024.
//

import SwiftUI

public struct PlaceholderEffectModifier: ViewModifier {
    
//    enum ShapeKind {
//        case rectangle(radius: Double)
//        case circle
//    }
//    
//    let shape: ShapeKind
    @State private var didAppear = false

    public func body(content: Content) -> some View {
        content
            .foregroundStyle(LinearGradient(colors: [.gray.opacity(didAppear ? 1 : 0.5), .gray.opacity(didAppear ? 0.5 : 1)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing))
            .onAppear {
                withAnimation(.linear(duration: 1.0).repeatForever()) {
                    didAppear = true
                }
            }
    }
}

public extension View {
    func placeholderEffect() -> some View {
        modifier(PlaceholderEffectModifier())
    }
}

private struct DemoPlaceholderEffectView: View {
    var body: some View {
        VStack {
            Spacer()
            
            Circle()
                .fill(.red)
                .frame(width: 150)
                .placeholderEffect()
            
            Spacer()
        }
    }
}

#Preview {
    DemoPlaceholderEffectView()
}
