//
//  SwiftUIView.swift
//  VisualKit
//
//  Created by Michel-André Chirita on 25/09/2024.
//

import SwiftUI

@available(iOS 17.0, *)
public struct AnimatedTextField: View {
    
    @Binding var text: String
    @State private var animated: Bool = false
    @State private var animatedReversed: Bool = false
    @State private var animationValue: Double = 0.0
    @State private var startDate = Date()
    @State private var animateImpulse = false
    @State private var animPercentCompletion = 0.0 // 1.0 fin anim bgd
    
    public init(text: Binding<String>) {
        self._text = text
    }
    
    public var body: some View {
        TimelineView(.animation) { time in
            ZStack {
                HStack {
                    Spacer(minLength: 30)
                    ZStack {
                        RoundedRectangle(cornerRadius: 30)
                            .fill(.white.opacity(0.4))
                            .stroke(Color.white, lineWidth: 1)
                            .blendMode(.lighten) // .overlay
                            .padding(3)
                            .rotation3DEffect(.degrees(animateImpulse ? 10 : 0), axis: (x: 0, y: 10, z: 0), perspective: -1)
                            .blur(radius: animateImpulse ? 3 : 0)
                        
                        RoundedRectangle(cornerRadius: 30)
                            .fill(.white.opacity(0.4))
                            .stroke(Color.white, lineWidth: 1)
                            .blendMode(.lighten) // .overlay
                            .padding(3)
                            .rotation3DEffect(.degrees(animateImpulse ? 10 * animPercentCompletion : 0), axis: (x: 0, y: 10, z: 0), perspective: 1)
                            .blur(radius: animateImpulse ? 3 : 0)
                        
                        ZStack(alignment: .leading) {
                            Text(text)
                                .font(.system(size: 22, weight: .bold, design: .rounded))
                                .foregroundStyle(LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                            
                            TextField("", text: $text)
                                .font(.system(size: 22, weight: .bold, design: .rounded))
                                .foregroundStyle(.black.opacity(1.0 - animPercentCompletion))
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                    }
                    .frame(height: 60)
                    .background {
                        RoundedRectangle(cornerRadius: 30)
                            .strokeBorder(AngularGradient(colors: [.blue, .orange, .purple, .red, .yellow, .blue], center: UnitPoint(x: animatedReversed ? 0 : 1.0, y: animatedReversed ? 0 : 1.0)), lineWidth: animateImpulse ? 50 : 50)
                            .blur(radius: animateImpulse ? 3 : 0)
                            .opacity(animateImpulse ? 0.5 : 1.0)
                            .hueRotation(Angle(degrees: animated ? 0 : 360))
                            .scaleEffect(x: animateImpulse ? 1.1 : 1.03)
                            .scaleEffect(y: animateImpulse ? 1.4 : 1.01)
                            .rotation3DEffect(.degrees(animateImpulse ? 10 * animPercentCompletion : 0), axis: (x: 0, y: 0, z: 5), perspective: -1)
                        
                        RoundedRectangle(cornerRadius: 30)
                            .strokeBorder(AngularGradient(colors: [.blue, .orange, .purple, .red, .yellow, .blue], center: UnitPoint(x: 0.5, y: animatedReversed ? 0 : 1.0)), lineWidth: animateImpulse ? 50 : 50)
                            .blur(radius: animateImpulse ? 20 : 7)
                            .hueRotation(Angle(degrees: animated ? 0 : 360))
                            .scaleEffect(x: animateImpulse ? 1.2 : 1.04)
                            .scaleEffect(y: animateImpulse ? 1.1 : 1.0)
                            .rotation3DEffect(.degrees(animateImpulse ? 10 * animPercentCompletion : 0), axis: (x: 0, y: 0, z: -5), perspective: 1)
                        
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .trim(from: 0.4 + animationValue, to: 0.5 + animationValue)
                            .stroke(.white, style: StrokeStyle(lineWidth: animateImpulse ? 20 : 10, lineCap: .round))
                            .blur(radius: 20) //animateImpulse ? 30 : 10)
                            .blendMode(.overlay)
                            .scaleEffect(x: animateImpulse ? 1.1 : 1.0)
                            .scaleEffect(y: animateImpulse ? 1.1 : 1.0)
                            .rotation3DEffect(.degrees(animateImpulse ? 10 * animPercentCompletion : 0), axis: (x: 0, y: 0, z: -5), perspective: 1)
                        
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .trim(from: 0.4 + animationValue, to: 0.5 + animationValue)
                            .stroke(.white, style: StrokeStyle(lineWidth: animateImpulse ? 20 : 10, lineCap: .round))
                            .rotationEffect(.degrees(180))
                            .blur(radius: 20)
                            .blendMode(.overlay)
                            .scaleEffect(x: animateImpulse ? 1.1 : 1.0)
                            .scaleEffect(y: animateImpulse ? 1.1 : 1.0)
                            .rotation3DEffect(.degrees(animateImpulse ? 10 * animPercentCompletion : 0), axis: (x: 0, y: 0, z: -5), perspective: 1)
                    }
                    .scaleEffect(animateImpulse ? 1.01 : 1.0)
                    
                    Spacer(minLength: 30)
                }
            }
        }
//        .background {
//            ZStack {
//                if #available(iOS 18.0, *) {
//                    GradientView()
//                        .ignoresSafeArea()
//                }
//
//                Color.purple.opacity(animPercentCompletion + 0.3)
//                    .ignoresSafeArea()
//                    .blendMode(.hue)
//                RadialGradient(colors: [.white, .white.opacity(0)], center: .center, startRadius: 0, endRadius: 1000)
//                    .ignoresSafeArea()
//                    .blendMode(.lighten)
//                    .opacity(animateImpulse ? 0.3 : 0.0)
//            }
//        }
        .onAppear {
            withAnimation(.linear(duration: 3.0).repeatForever(autoreverses: false)) {
                animated = true
                animationValue = 0.5
            }
            withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: true)) {
                animatedReversed = true
            }
        }
        .onChange(of: text) { oldValue, newValue in
            animPercentCompletion = (newValue.count > 10) ? 1.0 : Double(newValue.count) / 10
            
            withAnimation(.bouncy(duration: 0.3, extraBounce: 0.4)) {
                animateImpulse = true
            } completion: {
                animateImpulse = false
            }
        }
    }
    
    private let trimLength = 0.2
    
    private func startTrim(for date: Date) -> Double {
        let offset = date.timeIntervalSince(startDate) / 2
        let normalizedOffset = offset.truncatingRemainder(dividingBy: offset.rounded(.down))
        return normalizedOffset
    }
    
    private func endTrim(for date: Date) -> Double {
        let offset = date.timeIntervalSince(startDate) / 2
        let normalizedOffset = offset.truncatingRemainder(dividingBy: offset.rounded(.down))
        return normalizedOffset + trimLength
    }
}

#Preview {
    if #available(iOS 17.0, *) {
        AnimatedTextField(text: .constant(""))
    } else {
        // Fallback on earlier versions
    }
}
