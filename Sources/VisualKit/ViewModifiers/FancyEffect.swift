//
//  SwiftUIView.swift
//  VisualKit
//
//  Created by Michel-André Chirita on 04/10/2024.
//

import SwiftUI

public enum FancyEffect {
    case bounce(asymmetric: Bool)
    case shake(angle: Angle = .zero)
}

public enum EffectRepeat {
    case none
    case count(Int, pause: Double = 0, pauseEvery: Int = 1)
    case forever(pause: Double = 0, pauseEvery: Int = 1)
    
    var count: Int {
        switch self {
        case .none: 1
        case .count(let count, _, _): count
        case .forever: 999
        }
    }
    
    var pause: Double {
        switch self {
        case .none: 0
        case .count(_, let pause, _): pause
        case .forever(let pause, _): pause
        }
    }
    
    var pauseEvery: Int {
        switch self {
        case .none: 0
        case .count(_, _, let pauseEvery): pauseEvery
        case .forever(_, let pauseEvery): pauseEvery
        }
    }
}

@available(iOS 16.0, *)
struct FancyEffectModifier: ViewModifier {
    
    @Binding var trigger: Bool
    @State var xOffset: Double = 0
    @State var xScale: Double = 1
    @State var yScale: Double = 1
    let effect: FancyEffect
    let intensity: Double
    let speedMultiplier: Double
    let repeatEffect: EffectRepeat
    let rotation: Double
    let duration: Double = 0.3
    @State private var animationTask: Task<(), Never>?
    
    func body(content: Content) -> some View {
        switch effect {
        case .bounce(let asymmetric):
            bounceEffect(content: content, asymmetric: asymmetric)
        case .shake(let angle):
            shakeEffect(content: content, angle: angle)
        }
    }
    
    @ViewBuilder
    private func bounceEffect(content: Content, asymmetric: Bool) -> some View {
        content
            .scaleEffect(x: xScale,
                         y: yScale)
            .onChange(of: trigger) { value in
                animationTask?.cancel()
                if value {
                    self.animationTask = Task {
                        await animateBounce(duration: self.duration * 2, asymmetric: asymmetric)
                        trigger = false
                    }
                } else {
                    Task { await resetAnimation() }
                }
            }
    }
    
    private func animateBounce(duration: Double, asymmetric: Bool) async {
        let offsetRange = 0.3 * intensity
        let repeatCount = repeatEffect.count
        let duration = duration / speedMultiplier * Double(repeatEffect.count)
        let factor1 = 0.9
        let eachDuration = duration * factor1 / CGFloat(repeatEffect.count)
        await animateRepeatdly() {
            await scaleAllDirections(duration: eachDuration, offset: offsetRange, asymmetric: asymmetric)
        }
        
        let factor2 = 0.1
        await animate(duration: duration * factor2) {
            xScale = 1.0
            yScale = 1.0
        }
    }
    
    private func scaleAllDirections(duration: CGFloat, offset: CGFloat, asymmetric: Bool) async {
        let duration = duration / (asymmetric ? 4 : 2)
        await animate(duration: duration) {
            self.xScale = 1 + offset
            if !asymmetric { self.yScale = 1 + offset }
        }

        await animate(duration: duration) {
            self.xScale = 1 - offset
            if !asymmetric { self.yScale = 1 - offset }
        }
        
        if asymmetric {
            await animate(duration: duration) {
                self.xScale = 1
                self.yScale = 1 + offset
            }
            
            await animate(duration: duration) {
                self.yScale = 1 - offset
            }
        }
    }
    
    @ViewBuilder
    private func shakeEffect(content: Content, angle: Angle) -> some View {
        content
            .offset(x: xOffset)
            .rotationEffect(angle)
            .onChange(of: trigger) { value in
                animationTask?.cancel()
                if value {
                    self.animationTask = Task {
                        await animateShake(duration: self.duration / 2)
                        trigger = false
                    }
                } else {
                    Task { await resetAnimation() }
                }
            }
    }
    
    private func resetAnimation() async {
        await animate(duration: 0.1) {
            self.xScale = 1
            self.yScale = 1
            self.xOffset = 0
        }
    }
    
    private func animateShake(duration: Double) async {
        let offsetRange = 5.0 * intensity
        let duration = duration / speedMultiplier * Double(repeatEffect.count)
        let factor1 = 0.9
        let eachDuration = duration * factor1 / CGFloat(repeatEffect.count)
        await animateRepeatdly() {
            await backAndForthAnimation(duration: eachDuration, offset: offsetRange)
        }
        
        let factor2 = 0.1
        await animate(duration: duration * factor2) {
            xOffset = 0.0
        }
    }
    
    private func animateRepeatdly(animationBlock: () async -> Void) async {
        for index in 0..<repeatEffect.count {
            guard animationTask?.isCancelled != true else {
                await resetAnimation()
                return
            }
            await animationBlock()
            if repeatEffect.pause > 0, index % repeatEffect.pauseEvery == 0 {
                await resetAnimation()
                try? await Task.sleep(for: .seconds(repeatEffect.pause))
            }
        }
    }
    
    private func backAndForthAnimation(duration: CGFloat, offset: CGFloat) async {
        let halfDuration = duration / 2
        await animate(duration: halfDuration) {
            self.xOffset = offset
        }
        
        await animate(duration: halfDuration) {
            self.xOffset = -offset
        }
    }
}

@available(iOS 16.0, *)
public extension View {
    public func fancyEffect(trigger: Binding<Bool>,
                            effect: FancyEffect,
                            intensity: Double = 1.0,
                            speedMultiplier: Double = 1.0,
                            repeatEffect: EffectRepeat = .none,
                            rotation: Double = 0) -> some View {
        self
            .modifier(FancyEffectModifier(trigger: trigger,
                                          effect: effect,
                                          intensity: intensity,
                                          speedMultiplier: speedMultiplier,
                                          repeatEffect: repeatEffect,
                                          rotation: rotation))
    }
}

#Preview {
    if #available(iOS 16.0, *) {
        Text("Hello, world!")
            .fancyEffect(trigger: .constant(false), effect: .shake())
    } else {
        // Fallback on earlier versions
    }
}
