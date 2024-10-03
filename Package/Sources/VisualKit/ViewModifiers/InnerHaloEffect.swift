//
//  SwiftUIView.swift
//  VisualKit
//
//  Created by Michel-André Chirita on 01/10/2024.
//

import SwiftUI

struct InnerHaloModifier: ViewModifier {

    @Binding var trigger: Bool
    let cornerRadius: Double
    let color: Color
    let intensity: Double
    let speedMultiplier: Double
    let duration: Double = 0.3
    
    func body(content: Content) -> some View {
        content
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(color, lineWidth: 50 * intensity)
                    .ignoresSafeArea()
                    .blur(radius: 20 * intensity)
                    .opacity(trigger ? 1 : 0)
                    .allowsHitTesting(false)
            }
            .onChange(of: trigger) { value in
                guard trigger == true else { return }

                if #available(iOS 17.0, *) {
                    withAnimation(.easeOut(duration: duration / speedMultiplier)) {
                        trigger = true
                    } completion: {
                        withAnimation(.easeIn(duration: duration / speedMultiplier)) {
                            trigger = false
                        }
                    }
                } else {
                    withAnimation(.easeOut(duration: duration / speedMultiplier)) {
                        trigger = true
                    }
                    withAnimation(.easeIn(duration: duration / speedMultiplier).delay(duration / speedMultiplier)) {
                        trigger = false
                    }
                }
            }
    }
}

public extension View {
    public func innerHaloEffect(cornerRadius: Double = 80, color: Color = .red, trigger: Binding<Bool>, intensity: Double = 1.0, speedMultiplier: Double = 1.0) -> some View {
        self
            .modifier(InnerHaloModifier(trigger: trigger, cornerRadius: cornerRadius, color: color, intensity: intensity, speedMultiplier: speedMultiplier))
    }
}

#Preview {
    Text("Hello, world!")
        .modifier(InnerHaloModifier(trigger: .constant(true), cornerRadius: 80, color: .red, intensity: 1.0, speedMultiplier: 1.0))
}
