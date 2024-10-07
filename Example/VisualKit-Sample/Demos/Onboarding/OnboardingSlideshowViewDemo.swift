//
//  OnboardingSlideshowViewDemo.swift
//  VisualKit-Sample
//
//  Created by Michel-André Chirita on 06/10/2024.
//

import SwiftUI
import VisualKit

struct OnboardingSlideshowViewDemo: View {
    
    enum Style {
        case first
        case second
    }
    
    let style: Style
    @State private var animate: Bool = false
    @State private var animateValue: Int = 0
    let images: [ImageResource] = [.sample, .sample2, .sample4, .sample5, .sample6, .sample7, .sample8, .sample9, .sample3]
    
    var body: some View {
        VStack {
            Spacer()
            
            ZStack {
                ForEach(0..<30) { id in
                    slide(id: id)
                        .shadow(radius: 50)
                }
            }
            .frame(height: 500)
        
            GenericButton("Continue") {}
            
            Spacer()
        }
        .background(.black)
        .task {
            animate = true
            for x in 1..<30 {
                animateValue = x
                try? await Task.sleep(for: .seconds(2.0))
            }
        }
    }
    
    enum Phases: Int, CaseIterable {
        case initial
        case first
        case second
        case final
        
        var offset: Double {
            switch self {
            case .initial: -300
            case .first: -230
            case .second: -210
            case .final: -150
            }
        }
        
        var rotation: Double {
            switch self {
            case .initial: -90
            case .first: -60
            case .second: -50
            case .final: -20
            }
        }
        
        var opacity: Double {
            switch self {
            case .initial: 1
            case .first: 1
            case .second: 2
            case .final: 0
            }
        }
        
        var blur: Double {
            switch self {
            case .initial: 40
            case .first: 0
            case .second: -20
            case .final: 40
            }
        }
    }
    
    private struct AnimationValues {
        var offset = -300.0
        var rotation = -120.0
        var opacity: Double
        var blur = 40.0
        
        init(with style: Style) {
            switch style {
            case .first: opacity = 1
            case .second: opacity = 0
            }
        }
    }
    
    private struct AnimationValues2 {
        var offset = -150.0
        var opacity = 0.0
    }

    @ViewBuilder
    private func slide(id: Int) -> some View {
        slideContainer
            .blur(radius: 40)
            .scaleEffect(y: 1.2)
            .keyframeAnimator(initialValue: AnimationValues2(), trigger: animateValue >= id) { content, value in
                content
                    .opacity(value.opacity)
                    .offset(x: value.offset)
            } keyframes: { value in
                KeyframeTrack(\.offset) {
                    CubicKeyframe(-250, duration: 3)
                    CubicKeyframe(-400, duration: 3)
                    CubicKeyframe(-400, duration: 1)
                }
                
                KeyframeTrack(\.opacity) {
                    CubicKeyframe(0.5, duration: 3)
                    CubicKeyframe(1.0, duration: 3)
                    CubicKeyframe(0, duration: 1)
                }
            }
        
        Image(images[id % images.count])
            .resizable()
            .aspectRatio(contentMode: .fill)
            .containerRelativeFrame(.vertical)
            .mask {
                slideContainer
                    .keyframeAnimator(initialValue: AnimationValues(with: style), trigger: animateValue >= id) { content, value in
                        content
                            .rotation3DEffect(.degrees(value.rotation),
                                              axis: (x: 0, y: 1, z: 0),
                                              perspective: 1.1)
                            .offset(x: value.offset)
                            .opacity(value.opacity)
                            .blur(radius: style == .first ? 0 : 10)
                    } keyframes: { value in
                        KeyframeTrack(\.offset) {
                            CubicKeyframe(-250, duration: 3)
                            CubicKeyframe(-180, duration: 3)
                            CubicKeyframe(-150, duration: 1)
                        }
                        
                        KeyframeTrack(\.rotation) {
                            CubicKeyframe(-80, duration: 3)
                            CubicKeyframe(-30, duration: 3)
                            CubicKeyframe(-20, duration: 1)
                        }
                        
                        KeyframeTrack(\.opacity) {
                            CubicKeyframe(style == .first ? 1 : 0.0,
                                          duration: style == .first ? 2 : 4)
                            CubicKeyframe(1.0,
                                          duration: style == .first ? 4 : 2)
                            CubicKeyframe(0,
                                          duration: 1)
                        }
                    }
                
            }
            .keyframeAnimator(initialValue: AnimationValues(with: style), trigger: animateValue >= id) { content, value in
                content
                    .blur(radius: value.blur)
            } keyframes: { value in
                KeyframeTrack(\.blur) {
                    CubicKeyframe(30, duration: 3)
                    CubicKeyframe(0, duration: 1)
                    CubicKeyframe(0, duration: 2)
                    CubicKeyframe(20, duration: 1)
                }
            }
    }
    
//    @ViewBuilder
//    private func slide(id: Int) -> some View {
//        PhaseAnimator([Phases.initial, .first, .second, .final]) { phase in
//            slideContainer
//                .blur(radius: 40)
//                .scaleEffect(y: 1.2)
//                .offset(x: animate ? -300 : -150)
//                .opacity(animate ? 2.0 : 0)
//                .animation(.easeInOut(duration: 5.0).delay(Double(id) * 1.5), value: animate)
//            
//            Image(images[id % images.count])
//                .resizable()
//                .aspectRatio(contentMode: .fill)
//                .containerRelativeFrame(.vertical)
//                .mask {
//                    slideContainer
////                        .scaleEffect(x: 0.9, y: 0.7)
//                        .rotation3DEffect(.degrees(animate ? -20 : -90),
//                                          axis: (x: 0, y: 1, z: 0),
//                                          perspective: 1.1)
//                        .offset(x: animate ? -150 : -300)
//                        .opacity(animate ? 0 : 8)
//                }
//                .blur(radius: animate ? -40 : 40)
//                .blur(radius: animate ? 40 : -120)
//                .animation(.easeInOut(duration: 5.0).delay(Double(id) * 1.5), value: animate)
//        }
//    }
    
    @ViewBuilder
    private var slideContainer: some View {
        Rectangle()
            .fill(.black)
            .mask {
                Circle()
                    .scaleEffect(y: 2)
            }
            .mask {
                Circle()
                    .scaleEffect(x: 2)
            }
            .mask {
                LinearGradient(colors: [.black.opacity(0), .black.opacity(1.0)], startPoint: .init(x: 0.5, y: 0.5), endPoint: .trailing)
            }
//        RoundedRectangle(cornerRadius: 200)
//            .fill(.black)
    }
}

#Preview {
    OnboardingSlideshowViewDemo(style: .first)
}
