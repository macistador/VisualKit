//
//  SwiftUIView.swift
//  VisualKit
//
//  Created by Michel-André Chirita on 01/10/2024.
//

import SwiftUI

public struct AnimatedDecorationsView: View {
    
    public enum Scene {
        case circles
        case bubbles(withBlur: Bool)
        case lines
    }
    
    struct Animations {
        var animation1: Bool = false
        var animation2: Bool = false
        var animation3: Bool = false
        var animation4: Bool = false
        var animation5: Bool = false
    }

    let scene: Scene
    let color: Color
    let speedMultiplier: Double
    @State private var animations: Animations = Animations()
    
    public init(scene: Scene, color: Color = .white, speedMultiplier: Double = 1.0) {
        self.scene = scene
        self.color = color
        self.speedMultiplier = speedMultiplier
    }
    
    public var body: some View {
        switch scene {
        case .circles:
            circles
        case .bubbles(let withBlur):
            scene2(withBlur: withBlur)
        case .lines:
            DecorationsLinesView(color: color, speedMultiplier: speedMultiplier)
        }
    }
    
    // MARK: - Scene 1
    
    @ViewBuilder
    private var circles: some View {
        ZStack {
            let circleSize = 820.0 // 600.0
            let borderWidth = 210.0 // 200.0
            GeometryReader { reader in
                Circle()
                    .stroke(color.opacity(0.2), lineWidth: borderWidth)
                    .frame(width: circleSize, height: circleSize)
                    .scaleEffect(animations.animation1 ? 0.6 : 0.2)
                    .offset(x: reader.size.width * 0.2, y: reader.size.height * -0.3)
                Circle()
                    .stroke(color.opacity(0.2), lineWidth: borderWidth)
                    .frame(width: circleSize, height: circleSize)
                    .scaleEffect(animations.animation1 ? 1.2 : 0.8)
                    .offset(x: reader.size.width * 0.2, y: reader.size.height * -0.3)
                Circle()
                    .stroke(color.opacity(0.2), lineWidth: borderWidth)
                    .frame(width: circleSize, height: circleSize)
                    .scaleEffect(animations.animation1 ? 2.4 : 1.6)
                    .offset(x: reader.size.width * 0.2, y: reader.size.height * -0.3)
            }
        }
        .animation(.easeInOut(duration: 10.0 / speedMultiplier).delay(0.5).repeatForever(autoreverses: true), value: animations.animation1)
        .onAppear {
            animations.animation1.toggle()
        }
    }
    
    @ViewBuilder
    private func circle(borderLenght: Double) -> some View {
        Circle()
            .border(color.opacity(0.2), width: borderLenght)
    }
    
    // MARK: - Scene 2
    
    @ViewBuilder
    private func scene2(withBlur: Bool) -> some View {
        ZStack {
            GeometryReader { reader in
                ForEach(0...15, id:\.self) { index in
                    Circle()
                        .fill(color.opacity(0.2))
                        .aspectRatio(1, contentMode: .fit)
                        .frame(width: Double(Int.random(in: 10..<100)))
                        .scaleEffect(animationBool(for: index) ? Double.random(in: 1.5..<2.0) : Double.random(in: 0.5..<1.0))
                        .position(x: reader.size.width * Double.random(in: 0.0..<1.0),
                                  y: reader.size.height * Double.random(in: 0.0..<1.0))
                        .blur(radius: withBlur ? (animationBool(for: index) ? (Double(Int.random(in: 1..<10))) : 0) : 0)
                        .animation(animation(for: animationIndex(for: index)), value: animationBool(for: index))
                }
            }
            .onAppear {
                animations.animation1.toggle()
                animations.animation2.toggle()
                animations.animation3.toggle()
                animations.animation4.toggle()
                animations.animation5.toggle()
            }
        }
    }
    
    private func animationBool(for index: Int) -> Bool {
        [animations.animation1, animations.animation2, animations.animation3, animations.animation4][animationIndex(for: index)]
    }
    
    private func animationIndex(for index: Int) -> Int {
        Int(CGFloat(index).truncatingRemainder(dividingBy:4))
    }
    
    private func animation(for index: Int) -> Animation {
        switch index {
        case 1: .easeInOut(duration: 15.0 / speedMultiplier).delay(0).repeatForever(autoreverses: true)
        case 2: .easeInOut(duration: 13.0 / speedMultiplier).delay(0.5).repeatForever(autoreverses: true)
        case 3: .easeInOut(duration: 11.0 / speedMultiplier).delay(1.0).repeatForever(autoreverses: true)
        default: .easeInOut(duration: 9.0 / speedMultiplier).delay(1.5).repeatForever(autoreverses: true)
        }
    }
}

#Preview {
    AnimatedDecorationsView(scene: .circles)
}
