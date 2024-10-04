//
//  SwiftUIView.swift
//  VisualKit
//
//  Created by Michel-André Chirita on 01/10/2024.
//

import SwiftUI

public enum HaloColor {
    case color(Color)
    case gradient([Color])
    case meshGradient([Color])
    
    var style: any ShapeStyle {
        switch self {
        case .color(let color): color
        case .gradient(let colors): LinearGradient(colors: colors, startPoint: .top, endPoint: .bottom)
        case .meshGradient(let colors): Color.blue
        }
    }
}

struct InnerHaloModifier: ViewModifier {

    @Binding var trigger: Bool
    @Binding var progress: Double?
    let cornerRadius: Double
    let color: HaloColor
    let intensity: Double
    let speedMultiplier: Double
    let duration: Double = 0.3
    
    func body(content: Content) -> some View {
        var lineWidth: Double = 50 * intensity
        var blurRadius: Double = 20 * intensity
        var opacity: Double = trigger ? 1 : 0
        if let progress {
            lineWidth = lineWidth * progress
            blurRadius = blurRadius * progress
            opacity = progress
        }
        
        return content
            .overlay {
                ZStack {
                    switch color {
                    case .color(let color):
                        effectView(blurRadius: blurRadius, opacity: opacity / 2) {
                            RoundedRectangle(cornerRadius: cornerRadius)
                                .stroke(color,
                                        lineWidth: lineWidth)
                        }
                        effectView(blurRadius: blurRadius / 2, opacity: opacity) {
                            RoundedRectangle(cornerRadius: cornerRadius)
                                .stroke(color,
                                        lineWidth: lineWidth / 2)
                        }
                    case .gradient(let colors):
                        effectView(blurRadius: blurRadius, opacity: opacity / 2) {
                            RoundedRectangle(cornerRadius: cornerRadius)
                                .stroke(LinearGradient(colors: colors, startPoint: .top, endPoint: .bottom),
                                        lineWidth: lineWidth)
                        }
                        effectView(blurRadius: blurRadius / 2, opacity: opacity) {
                            RoundedRectangle(cornerRadius: cornerRadius)
                                .stroke(LinearGradient(colors: colors, startPoint: .top, endPoint: .bottom),
                                        lineWidth: lineWidth / 2)
                        }
                    case .meshGradient(let colors):
                        if #available(iOS 18, *) {
                            effectView(blurRadius: blurRadius, opacity: opacity / 2) {
                                RoundedRectangle(cornerRadius: cornerRadius)
                                    .stroke(MeshGradient(width: 2, height: 5, points: [
                                        [0.0, 0.0], [1.0, 0.0],
                                        [0.0, 0.25], [1.0, 0.25],
                                        [0.0, 0.5], [1.0, 0.5],
                                        [0.0, 0.75], [1.0, 0.75],
                                        [0.0, 1.0], [1.0, 1.0]
                                    ], colors: colors),
                                            lineWidth: lineWidth)
                            }
                             
                            effectView(blurRadius: blurRadius / 2, opacity: opacity) {
                                RoundedRectangle(cornerRadius: cornerRadius)
                                    .stroke(MeshGradient(width: 2, height: 5, points: [
                                        [0.0, 0.0], [1.0, 0.0],
                                        [0.0, 0.25], [1.0, 0.25],
                                        [0.0, 0.5], [1.0, 0.5],
                                        [0.0, 0.75], [1.0, 0.75],
                                        [0.0, 1.0], [1.0, 1.0]
                                    ], colors: colors),
                                            lineWidth: lineWidth / 2)
                            }
                        } else {
                            RoundedRectangle(cornerRadius: cornerRadius)
                                .stroke(LinearGradient(colors: colors, startPoint: .top, endPoint: .bottom),
                                        lineWidth: lineWidth)
                                .ignoresSafeArea()
                                .blur(radius: blurRadius)
                                .opacity(opacity)
                                .allowsHitTesting(false)
                        }
                    }
                }
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
    
    @ViewBuilder
    private func effectView<T: View>(blurRadius: Double, opacity: Double, @ViewBuilder content: ()->T) -> some View {
        content()
            .ignoresSafeArea()
            .blur(radius: blurRadius)
            .opacity(opacity)
    }
}

public extension View {
    public func innerHaloEffect(trigger: Binding<Bool> = .constant(true), progress: Binding<Double?> = .constant(nil), cornerRadius: Double = 60, color: HaloColor = .color(.red), intensity: Double = 1.0, speedMultiplier: Double = 1.0) -> some View {
        self
            .modifier(InnerHaloModifier(trigger: trigger, progress: progress, cornerRadius: cornerRadius, color: color, intensity: intensity, speedMultiplier: speedMultiplier))
    }
}

#Preview {
    Text("Hello, world!")
        .innerHaloEffect(trigger: .constant(false))
}
