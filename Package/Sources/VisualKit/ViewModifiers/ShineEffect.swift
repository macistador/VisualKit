//
//  File.swift
//  VisualKit
//
//  Created by Michel-André Chirita on 22/09/2024.
//

import SwiftUI

private struct DemoShineEffectModifier: View {
    var body: some View {
        VStack {
            Spacer()
            
            Circle()
                .fill(.red)
                .frame(width: 150)
                .shineEffect(shape: .circle, borderWidth: 50)
//                .frame(height: 350)

            ShineEffect(content: RoundedRectangle(cornerRadius: 40))
            
            ShineEffect(content: Arc(startAngle: .zero, endAngle: .degrees(90), clockwise: true))
                .scaleEffect(0.6)
                .rotationEffect(.degrees(136))
            
            Spacer()
        }
    }
}

private struct Arc: InsettableShape {

    var startAngle: Angle
    var endAngle: Angle
    var clockwise: Bool
    var insetAmount = 0.0

    func inset(by amount: CGFloat) -> some InsettableShape {
        var arc = self
        arc.insetAmount += amount
        return arc
    }
    
    func path(in rect: CGRect) -> Path {
        let rotationAdjustment = Angle.degrees(90)
        let modifiedStart = startAngle - rotationAdjustment
        let modifiedEnd = endAngle - rotationAdjustment

        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width / 2, startAngle: modifiedStart, endAngle: modifiedEnd, clockwise: !clockwise)
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width / 2, startAngle: modifiedStart - Angle.degrees(90), endAngle: modifiedEnd + Angle.degrees(80), clockwise: clockwise)

        return path
    }
}

public struct ShineEffectModifier: ViewModifier {
    
    //    var shape: any Shape
    public enum ShapeKind {
        case rectangle(radius: Double)
        case circle
    }
    
    let shape: ShapeKind
    var borderWidth: Double = 30.0
    @State private var animated: Bool = false
    @State private var animatedReversed: Bool = false
    @State private var animationValue: Double = 0.0
    @State private var startDate = Date()
    @State private var animateImpulse = false
    @State private var animPercentCompletion = 0.0 // 1.0 fin anim bgd
    
    public func body(content: Content) -> some View {
        ZStack {
            content
            switch shape {
            case .rectangle(let radius):
                ShineEffect(content: RoundedRectangle(cornerRadius: radius),
                            borderWidth: borderWidth)
            case .circle:
                ShineEffect(content: Circle(),
                            borderWidth: borderWidth)
            }
        }
    }
}

public struct ShineEffect<Content: InsettableShape>: View {
    
    var content: Content
    var borderWidth: Double = 50.0
    //    @Binding var impulse: Int
    @State private var animated: Bool = false
    @State private var animatedReversed: Bool = false
    @State private var animationValue: Double = 0.0
    @State private var startDate = Date()
    @State private var animateImpulse = false
    @State private var animPercentCompletion = 0.0 // 1.0 fin anim bgd
    
    public init(content: Content, borderWidth: Double = 50) {
        self.content = content
        self.borderWidth = borderWidth
    }
    
    public var body: some View {
        TimelineView(.animation) { time in
            ZStack {
                content
                    .fill(.clear)
                HStack {
                    Spacer(minLength: borderWidth * 0.6)
                    ZStack {
                        content
                            .fill(.clear)
                    }
                    .background {
                        // This one is optionnal:
//                        content
//                            .strokeBorder(AngularGradient(colors: [.blue, .orange, .purple, .red, .yellow, .blue],
//                                                          center: UnitPoint(x: animatedReversed ? 0 : 1.0,
//                                                                            y: animatedReversed ? 0 : 1.0)),
//                                          lineWidth: 1) //animateImpulse ? borderWidth * 0.6 : borderWidth * 0.6)
//                            .blur(radius: animateImpulse ? borderWidth * 0.06 : 0)
//                            .opacity(animateImpulse ? 0.5 : 1.0)
//                            .hueRotation(Angle(degrees: animated ? 0 : 360))
//                            .scaleEffect(x: animateImpulse ? 1.1 : 1.03)
//                            .scaleEffect(y: animateImpulse ? 1.4 : 1.01)
//                            .rotation3DEffect(.degrees(animateImpulse ? 10 * animPercentCompletion : 0),
//                                              axis: (x: 0, y: 0, z: 5), perspective: -1)
                        
                        content
                            .strokeBorder(AngularGradient(colors: [.blue, .orange, .purple, .red, .yellow, .blue],
                                                          center: UnitPoint(x: 0.5,
                                                                            y: animatedReversed ? 0 : 1.0)),
                                          lineWidth: animateImpulse ? borderWidth : borderWidth)
//                            .blur(radius: animateImpulse ? borderWidth * 0.4 : borderWidth * 0.14)
                            .hueRotation(Angle(degrees: animated ? 0 : 360))
                            .scaleEffect(x: animateImpulse ? 1.2 : 1.04)
                            .scaleEffect(y: animateImpulse ? 1.1 : 1.0)
                            .rotation3DEffect(.degrees(animateImpulse ? 10 * animPercentCompletion : 0),
                                              axis: (x: 0, y: 0, z: -5),
                                              perspective: 1)
                        
//                        content
//                            .stroke(.white,
//                                    style: StrokeStyle(lineWidth: animateImpulse ? borderWidth * 0.4 : borderWidth / 5,
//                                                       lineCap: .round))
//                            .blur(radius: borderWidth * 0.4)
//                            .blendMode(.overlay)
//                            .scaleEffect(x: animateImpulse ? 1.1 : 1.0)
//                            .scaleEffect(y: animateImpulse ? 1.1 : 1.0)
//                            .rotation3DEffect(.degrees(animateImpulse ? 10 * animPercentCompletion : 0),
//                                              axis: (x: 0, y: 0, z: -5),
//                                              perspective: 1)
                        
//                        content
//                            .stroke(.white,
//                                    style: StrokeStyle(lineWidth: animateImpulse ? borderWidth * 0.4 : borderWidth / 5,
//                                                       lineCap: .round))
//                            .rotationEffect(.degrees(180))
//                            .blur(radius: borderWidth * 0.4)
//                            .blendMode(.overlay)
//                            .scaleEffect(x: animateImpulse ? 1.1 : 1.0)
//                            .scaleEffect(y: animateImpulse ? 1.1 : 1.0)
//                            .rotation3DEffect(.degrees(animateImpulse ? 10 * animPercentCompletion : 0),
//                                              axis: (x: 0, y: 0, z: -5),
//                                              perspective: 1)
                    }
                    .scaleEffect(animateImpulse ? 1.01 : 1.0)
                    
                    Spacer(minLength: borderWidth * 0.6)
                }
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 3.0).repeatForever(autoreverses: false)) {
                animated = true
                animationValue = 0.5
            }
            withAnimation(.linear(duration: 20.0).repeatForever(autoreverses: true)) {
                animatedReversed = true
            }
        }
    }
}

public extension View {
    func shineEffect(shape: ShineEffectModifier.ShapeKind, borderWidth: Double = 30) -> some View {
        modifier(ShineEffectModifier(shape: .circle, borderWidth: borderWidth))
    }
}

private extension Shape {
    func shineEffect() -> some Shape {
        self
    }
}

#Preview {
    DemoShineEffectModifier()
}

