//
//  SwiftUIView.swift
//  VisualKit
//
//  Created by Michel-André Chirita on 02/10/2024.
//

import SwiftUI

public enum FullScreenTitleKind {
    case first(text: String,
               rotation: Double = -5,
               textColor: Color = .black,
               textBorderColor: Color = .white,
               backgroundColor1: Color = .blue,
               backgroundColor2: Color = .red)
    case second(text: String,
                rotation: Double = 0,
                textColor1: Color = Color(red: 80/255, green: 5/255, blue: 232/255),
                textColor2: Color = Color(red: 151/255, green: 4/255, blue: 209/255),
                textBackground: Color = .black,
                backgroundColor: Color = Color(red: 80/255, green: 5/255, blue: 232/255))
}

struct FullScreenTitleModifier: ViewModifier {
    
    let kind: FullScreenTitleKind
    @Binding var trigger: Bool
    @State var innerTrigger: Bool = false
    @State var innerTrigger2: Bool = false
    let font: Font
    let intensity: Double
    let speedMultiplier: Double
    let pause: Double
        
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .center) {
//                if trigger {
                    switch kind {
                    case .first(let text, let rotation, let textColor, let textBorderColor, let backgroundColor1, let backgroundColor2): first(content: content, text: text, rotation: rotation, textColor: textColor, textBorderColor: textBorderColor, backgroundColor1: backgroundColor1, backgroundColor2: backgroundColor2)
                    case .second(let text, let rotation, let textColor1, let textColor2, let textBackgroundColor, let backgroundColor): second(content: content, text: text, rotation: rotation, textColor1: textColor1, textColor2: textColor2, textBackgroundColor: textBackgroundColor, backgroundColor: backgroundColor)
                    }
//                }
            }
    }
    
    @ViewBuilder
    private func second(content: Content, text: String, rotation: Double, textColor1: Color, textColor2: Color, textBackgroundColor: Color, backgroundColor: Color) -> some View {
        ZStack {
            Rectangle()
                .fill(backgroundColor)
            
            ZStack {
                if #available(iOS 18, *) {
                    Text(text)
                        .font(.system(size: 100, weight: .black))
                        .foregroundStyle(.clear)
                        .fixedSize()
                        .offset(x: innerTrigger2 ? -300 : 200)
                        .shadow(color: .white, radius: 0, x: -1, y: -1)
                        .blendMode(.colorBurn)
                        .background {
                            MeshGradient(width: 4, height: 3, points: [
                                [0.0, 0.0], [0.3, 0], [0.6, 0.0], [1.0, 0.0],
                                [0.0, 0.5], [innerTrigger2 ? 0.2 : 0.5, 0.5], [0.6, 0.5], [1.0, 0.5],
                                [0.0, 1.0], [0.3, 1.0], [6.0, 1.0], [1.0, 1.0]
                            ], colors: [
                                textColor1, textColor2, textColor1, textColor2,
                                textColor1, innerTrigger2 ? textColor2 : textColor1, textColor1, textColor1,
                                textColor1, textColor2, textColor1, textColor2
                            ],
                                         smoothsColors: true,
                                         colorSpace: .perceptual
                            )
                            .mask {
                                Text(text)
                                    .font(.system(size: 100, weight: .black))
                                    .fixedSize()
                                    .offset(x: innerTrigger2 ? -300 : 200)
                            }
                        }

                } else {
                    Text(text)
                        .font(.system(size: 100, weight: .black))
                        .foregroundStyle(textColor1)
                        .fixedSize()
                        .padding(5)
                        .offset(x: innerTrigger2 ? -300 : 200)
                }
            }
            .background(textBackgroundColor, in: .rect)
        }
        .opacity(innerTrigger ? 1.0 : 0.0)
        .onChange(of: trigger) { value in
            guard trigger == true else { return }
            let duration: Double = 0.5
            innerTrigger2 = false
            withAnimation(.bouncy(duration: duration / speedMultiplier,
                                  extraBounce: 0.2)) {
                innerTrigger = true
            }
            withAnimation(.linear(duration: (duration + 1.0) / speedMultiplier)){
                    innerTrigger2 = true
                }
            withAnimation(.easeIn(duration: duration / speedMultiplier)
                .delay((duration + 0.5) / speedMultiplier)) {
                    innerTrigger = false
                    trigger = false
                }
        }
    }
    
    @ViewBuilder
    private func first(content: Content, text: String, rotation: Double, textColor: Color, textBorderColor: Color, backgroundColor1: Color, backgroundColor2: Color) -> some View {
        ZStack {
            Rectangle()
                .fill(.regularMaterial)
                .opacity(innerTrigger ? 1.0 : 0.0)
            
            GeometryReader { reader in
                VStack {
                    Spacer()
                    ZStack {
                        let screenWidth = reader.size.width
                        Rectangle()
                            .fill(backgroundColor1)
                            .frame(width: screenWidth, height: 50)
                            .scaleEffect(x: 1.2)
                        //                                    .opacity(innerTrigger ? 1.0 : -3.0)
                            .offset(x: innerTrigger ? screenWidth * 0.35 : -screenWidth * 1.5, y: 30)
                            .rotation3DEffect(.degrees(3), axis: (x: 1, y: 0, z: 0), perspective: 10)
                            .rotationEffect(.degrees(innerTrigger ? 0 : 20))
                        Rectangle()
                            .fill(backgroundColor2)
                            .frame(width: screenWidth, height: 50)
                            .scaleEffect(x: 1.2)
                        //                                    .opacity(innerTrigger ? 1.0 : -3.0)
                            .offset(x: innerTrigger ? screenWidth * -0.3 : screenWidth * 2,
                                    y: 60)
                            .rotation3DEffect(.degrees(3), axis: (x: 1, y: 0, z: 0), perspective: -10)
                            .rotationEffect(.degrees(innerTrigger ? 0 : -20))
                        Text(text)
                            .font(font)
                            .fontWeight(.black)
                            .foregroundStyle(textColor)
                            .scaleEffect(innerTrigger ? 2 * intensity : 0.1)
                        //                                    .opacity(innerTrigger ? 1.0 : -3.0)
                            .offset(y: 30)
                            .shadow(color: textBorderColor, radius: 0, x: 3, y: 0)
                            .shadow(color: textBorderColor, radius: 0, x: -3, y: 0)
                            .shadow(color: textBorderColor, radius: 0, x: 0, y: 3)
                            .shadow(color: textBorderColor, radius: 0, x: 0, y: -3)
                    }
                    .rotationEffect(.degrees(innerTrigger ? rotation : 0))
                    .opacity(innerTrigger ? 1.0 : 0.0)
                    Spacer()
                }
            }
        }
        .onChange(of: trigger) { value in
            guard trigger == true else { return }
            let duration: Double = 0.3

            if #available(iOS 17.0, *) {
                withAnimation(.bouncy(duration: duration / speedMultiplier,
                                      extraBounce: 0.2)) {
                    innerTrigger = true
                } completion: {
                    withAnimation(.easeIn(duration: duration / speedMultiplier)
                        .delay(pause)) {
                            innerTrigger = false
                            trigger = false
                        }
                }
            } else {
                withAnimation(.bouncy(duration: duration / speedMultiplier,
                                      extraBounce: 0.2)) {
                    innerTrigger = true
                }
                withAnimation(.easeIn(duration: duration / speedMultiplier)
                    .delay(duration / speedMultiplier + pause)) {
                        innerTrigger = false
                        trigger = false
                    }
            }
        }
    }
}

public extension View {
    public func fullScreenTitleEffect(_ kind: FullScreenTitleKind, trigger: Binding<Bool>, font: Font = .title, intensity: Double = 1.0, speedMultiplier: Double = 1.0, pause: Double = 2.0) -> some View {
        self
            .modifier(FullScreenTitleModifier(kind: kind, trigger: trigger, font: font, intensity: intensity, speedMultiplier: speedMultiplier, pause: pause))
    }
}

#Preview {
    Text("Hello, world!")
        .fullScreenTitleEffect(.first(text: "Whaouuu!"), trigger: .constant(false))
}
