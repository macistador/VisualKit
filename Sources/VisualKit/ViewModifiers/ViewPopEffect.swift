//
//  SwiftUIView.swift
//  VisualKit
//
//  Created by Michel-André Chirita on 02/10/2024.
//

import SwiftUI

public enum ViewPopDirection {
    case top(offset: Int = 30)
    case bottom(offset: Int = 30)
    case left(offset: Int = 30)
    case right(offset: Int = 30)
    case custom(x: Int, y: Int)
    case over(scale: Double = 2)
    
    var offset: CGVector {
        switch self {
        case .top(let offset): CGVector(dx: 0, dy: -offset)
        case .bottom(let offset): CGVector(dx: 0, dy: offset)
        case .left(let offset): CGVector(dx: -offset, dy: 0)
        case .right(let offset): CGVector(dx: offset, dy: 0)
        case .custom(let x, let y): CGVector(dx: x, dy: y)
        case .over: .zero
        }
    }
    
    var scale: Double {
        switch self {
        case .over(let scale): scale
        default: 1.0
        }
    }
    
    var isOverlay: Bool {
        switch self {
        case .over: true
        default: false
        }
    }
}

struct ViewPopModifier<PopContent: View>: ViewModifier {
    
    @ViewBuilder var content: () -> PopContent
    @Binding var trigger: Bool
    @State var innerTrigger: Bool = false
    let direction: ViewPopDirection
    let intensity: Double
    let speedMultiplier: Double
    let pause: Double
    let rotation: Double
    let duration: Double = 0.3

    func body(content: Content) -> some View {
        content
            .overlay {
                if direction.isOverlay {
                    textView(scale: direction.scale)
                }
            }
            .background {
                if !direction.isOverlay {
                    textView(scale: direction.scale)
                }
            }
            .onChange(of: trigger) { value in
                guard trigger == true else { return }
                        
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
    
    @ViewBuilder
    private func textView(scale: Double) -> some View {
        content()
            .offset(x: innerTrigger ? direction.offset.dx : 0,
                    y: innerTrigger ? direction.offset.dy : 0)
            .scaleEffect(innerTrigger ? 2 * intensity * scale : 0.1)
            .opacity(innerTrigger ? 1.0 : 0.0)
            .rotationEffect(.degrees(innerTrigger ? rotation : 0))
    }
}

public extension View {
    public func viewPopEffect(text: String,
                              trigger: Binding<Bool>,
                              direction: ViewPopDirection = .top(),
                              color: Color? = nil,
                              font: Font = .title,
                              intensity: Double = 1.0,
                              speedMultiplier: Double = 1.0,
                              pause: Double = 0,
                              rotation: Double = 0) -> some View {
        self
            .modifier(ViewPopModifier(content: {
                Text(text)
                    .font(font)
                    .foregroundStyle(color ?? Color("primaryText", bundle: .module))
            },
                                      trigger: trigger,
                                      direction: direction,
                                      intensity: intensity,
                                      speedMultiplier: speedMultiplier,
                                      pause: pause,
                                      rotation: rotation))
    }
    
    public func viewPopEffect<Content: View>(trigger: Binding<Bool>,
                                             direction: ViewPopDirection = .top(),
                                             intensity: Double = 1.0,
                                             speedMultiplier: Double = 1.0,
                                             pause: Double = 0,
                                             rotation: Double = 0,
                                             @ViewBuilder view: @escaping ()->Content) -> some View {
        self
            .modifier(ViewPopModifier(content: view,
                                      trigger: trigger,
                                      direction: direction,
                                      intensity: intensity,
                                      speedMultiplier: speedMultiplier,
                                      pause: pause,
                                      rotation: rotation))
    }
}

#Preview {
    Text("Hello, world!")
        .viewPopEffect(trigger: .constant(false)) {
            Text("❤️")
        }
        .viewPopEffect(text: "❤️", trigger: .constant(false))
}
