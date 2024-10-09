//
//  SwiftUIView.swift
//  VisualKit
//
//  Created by Michel-André Chirita on 04/10/2024.
//

import SwiftUI

public enum ReflectionKind {
    case simple
    case triple
    
    var relativeWidth: Double {
        switch self {
        case .simple: 0.2
        case .triple: 0.3
        }
    }
}

@available(iOS 16.0, *)
struct ReflectionEffectModifier<Mask: View>: ViewModifier {

    @Binding var trigger: Bool
    @State var innerTrigger: Bool = false
    @Binding var progress: Double?
    @ViewBuilder let mask: () -> Mask
    let color: Color
    let intensity: Double
    let speedMultiplier: Double
    let duration: Double = 1.3
    @State var eachDuration: Double = 0
    let reflectionKind: ReflectionKind
    let repeatEffect: EffectRepeat
    @State private var animationTask: Task<(), Never>?

    func body(content: Content) -> some View {
        content
            .overlay(alignment: .leading) {
                GeometryReader { reader in
                    let width = reader.size.width * reflectionKind.relativeWidth
                    let maxOffset = reader.size.width + width
                    var xOffset = innerTrigger ? maxOffset : -width
                    if let progress {
                        xOffset = -width + (maxOffset + width) * progress
                    }
                    
                    return reflectionView(width: width)
                        .frame(height: reader.size.height * 3)
                        .offset(y: -reader.size.height * 3 / 2)
                        .rotationEffect(.degrees(-7))
                        .offset(x: xOffset)
                        .allowsHitTesting(false)
                        .opacity(1 * intensity)
                        .animation(.easeInOut(duration: innerTrigger ? eachDuration : 0),
                                   value: innerTrigger)
                }
                .mask(mask)
            }
            .onChange(of: trigger) { value in
                animationTask?.cancel()
                if value {
                    innerTrigger = false
                    self.animationTask = Task {
                        await animate()
                        innerTrigger = false
                        trigger = false
                    }
                } else {
                    innerTrigger = false
                }
            }
    }
    
    @ViewBuilder
    private func reflectionView(width: Double) -> some View {
        switch reflectionKind {
        case .simple:
            Rectangle()
                .foregroundStyle(color)
                .frame(width: width)
        case .triple:
            HStack(spacing: 0) {
                Rectangle()
                    .frame(width: width * 0.2)
                    .blur(radius: 2)
                    .padding(.trailing, 5)
                Rectangle()
                    .frame(width: width * 0.5)
                    .padding(.trailing, 10)
                Rectangle()
                    .frame(width: width * 0.2)
            }
            .foregroundStyle(color)
        }
    }
    
    private func animate() async {
        self.eachDuration = duration / speedMultiplier
        await animateRepeatdly() {
            innerTrigger = true
            try? await Task.sleep(for: .seconds(eachDuration))
            innerTrigger = false
        }
    }
    
    private func animateRepeatdly(animationBlock: () async -> Void) async {
        for index in 0..<repeatEffect.count {
            guard animationTask?.isCancelled != true else { return }
            await animationBlock()
            if repeatEffect.pause > 0, index % repeatEffect.pauseEvery == 0 {
                try? await Task.sleep(for: .seconds(repeatEffect.pause))
            }
        }
    }
}

@available(iOS 16.0, *)
public extension View {
    public func reflectionEffect<Mask: View>(trigger: Binding<Bool> = .constant(true), progress: Binding<Double?> = .constant(nil), color: Color = .white, intensity: Double = 1.0, speedMultiplier: Double = 1.0, repeatEffect: EffectRepeat = .none, reflectionKind: ReflectionKind = .simple, @ViewBuilder mask: @escaping () -> Mask) -> some View {
        self
            .modifier(ReflectionEffectModifier(trigger: trigger, progress: progress, mask: mask, color: color, intensity: intensity, speedMultiplier: speedMultiplier, reflectionKind: reflectionKind, repeatEffect: repeatEffect))
    }
}

#Preview {
    if #available(iOS 16.0, *) {
        Text("Hello, world!")
            .reflectionEffect(trigger: .constant(false)) { Text("Hello, world!") }
    } else {
        // Fallback on earlier versions
    }
}
