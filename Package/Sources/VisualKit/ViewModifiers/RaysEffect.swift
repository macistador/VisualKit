//
//  SwiftUIView.swift
//  VisualKit
//
//  Created by Michel-André Chirita on 22/09/2024.
//

import SwiftUI

public enum RaysEffectKind {
    case simple
    case flash
}

struct RaysEffectModifier: ViewModifier {
    
//    enum ShapeKind {
//        case rectangle(radius: Double)
//        case circle
//    }
//
//    let shape: ShapeKind
    let effectKind: RaysEffectKind
    @Binding var trigger: Bool
    let color: Color
    @State var innerPositionTrigger: Bool = false
    @State var innerVisibilityTrigger: Bool = false
    let intensity: Double = 1.0
    let speedMultiplier: Double = 1.0
    let pause: Double = 0.5
    let duration: Double = 0.3
    let length: Double = 6
    let raysCount: Int = 20
    let thisRaysCount: Int
    let offset: Double = 60
    let thisRotations: [Int]
    let thisThickness: [Int]

    init(effectKind: RaysEffectKind, trigger: Binding<Bool>, color: Color = .blue) {
        self.effectKind = effectKind
        self._trigger = trigger
        self.color = color
        self.thisRaysCount = Int.random(in: 10...20)
        var thisRotations: [Int] = []
        for id in 0...thisRaysCount {
            thisRotations.append(Int.random(in: 0...360))
        }
        self.thisRotations = thisRotations

        var thisThickness: [Int] = []
        for id in 0...thisRaysCount {
            thisThickness.append(Int.random(in: 6...30))
        }
        self.thisThickness = thisThickness
    }
    
    public func body(content: Content) -> some View {
        content
            .background(alignment: .center) {
                ZStack {
                    switch effectKind {
                    case .simple:
                        simpleEffectView(content: content, length: length, offset: offset)
    //                    simpleEffectView(content: content, length: length / 2, offset: offset * 1.2, extraDelay: 0.2)
                    case .flash:
                        flexEffectView(content: content, length: length, offset: offset)
                    }
                }
                .offset(x: length / 2, y: 0)
            }
    }
    
    @ViewBuilder
    private func flexEffectView(content: Content, length: Double, offset: Double, extraDelay: Double = 0) -> some View {
        let length = 1000.0
        let offset = 1000.0
        
        return ForEach(0...thisRaysCount, id: \.self) { id in
            let thisRotation = Double(thisRotations[id])
            RoundedRectangle(cornerRadius: 0)
                .fill(color)
                .frame(width: length, height: Double(thisThickness[id]))
                .offset(x: innerPositionTrigger ? offset : 0, y: 0)
                .scaleEffect(innerPositionTrigger ? 1.0 : 0.1, anchor: .leading)
                .rotationEffect(.degrees(Double(thisRotation)), anchor: .leading)
                .opacity(innerVisibilityTrigger ? 1 : 0)
                .offset(x: length / 2, y: 0)
        }
        .onChange(of: trigger) { value in
            innerPositionTrigger = false
            innerVisibilityTrigger = false
            let duration = 0.3
            
            guard value == true else { return }
            withAnimation(.easeOut(duration: duration / speedMultiplier).delay(extraDelay)) {
                innerPositionTrigger = true
                innerVisibilityTrigger = true
            }
            withAnimation(.easeIn(duration: duration / speedMultiplier)
                .delay(duration / speedMultiplier / 3 + pause + extraDelay)) {
                    innerVisibilityTrigger = false
                }
            withAnimation(.easeIn(duration: duration / speedMultiplier)
                .delay(duration / speedMultiplier + pause + extraDelay)) {
                    innerPositionTrigger = false
                    trigger = false
                }
        }
    }
    
    @ViewBuilder
    private func simpleEffectView(content: Content, length: Double, offset: Double, extraDelay: Double = 0) -> some View {
        ForEach(0...raysCount, id: \.self) { id in
            RoundedRectangle(cornerRadius: 20)
                .fill(color)
                .frame(width: length, height: 4)
                .scaleEffect(innerPositionTrigger ? 1.0 : 0.1)
                .offset(x: innerPositionTrigger ? offset : 0, y: 0)
                .rotationEffect(.degrees(Double(id * 360 / raysCount)), anchor: .leading)
                .opacity(innerVisibilityTrigger ? 1 : 0)
        }
        .onChange(of: trigger) { value in
            guard trigger == true else { return }
            innerPositionTrigger = false
            innerVisibilityTrigger = false
            
            withAnimation(.bouncy(duration: duration / speedMultiplier,
                                  extraBounce: 0.3).delay(extraDelay)) {
                innerPositionTrigger = true
                innerVisibilityTrigger = true
            }
            withAnimation(.easeIn(duration: duration / speedMultiplier)
                .delay(duration / speedMultiplier / 3 + pause + extraDelay)) {
                    innerVisibilityTrigger = false
                }
            withAnimation(.easeIn(duration: duration / speedMultiplier)
                .delay(duration / speedMultiplier + pause + extraDelay)) {
                    innerPositionTrigger = false
                    trigger = false
                }
        }
    }
}

public extension View {
    func raysEffect(_ effectKind: RaysEffectKind = .simple, trigger: Binding<Bool>) -> some View {
        modifier(RaysEffectModifier(effectKind: effectKind, trigger: trigger))
    }
}

#Preview {
    Circle()
        .fill(.blue)
        .raysEffect(trigger: .constant(false))
}
