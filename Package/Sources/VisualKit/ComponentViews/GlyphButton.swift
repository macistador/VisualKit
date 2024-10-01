//
//  SwiftUIView.swift
//  VisualKit
//
//  Created by Michel-André Chirita on 28/09/2024.
//

import SwiftUI

public struct GlyphButton: View {
    
    public static var colors: Colors = Colors()
    public static var size: Double = 18
    public static var borderWidth: Double = 1
    public static var innerPadding: Double = 7
    public static var hasShadow: Bool = true
    public static var hasHaptic: Bool = true
    public static var isAnimated: Bool = true
    public static var isBlinking: Bool = false

    private let iconName: String
    @Binding private var state: ButtonState
    private let size: Double
    private let borderWidth: Double
    private let innerPadding: Double
    private let colors: Colors
    private let hasShadow: Bool
    private let hasHaptic: Bool
    private let isAnimated: Bool
    @Binding private var isBlinking: Bool
    private let action: ()->Void
    @State private var animate: Bool = false
    @State private var animateBlink: Bool = false

    public enum ButtonState {
        case enabled
        case disabled
        case loading
    }
    
    public struct Colors {
        let glyphColor: Color
        let backgroundTop: Color
        let backgroundBottom: Color
        let border: Color
        let disabledOverlay: Color
        let waveOverlay: Color

        public init(glyphColor: Color? = nil,
                    backgroundTop: Color? = nil,
                    backgroundBottom: Color? = nil,
                    border: Color? = nil,
                    disabledOverlay: Color? = nil,
                    waveOverlay: Color? = nil) {
            self.glyphColor = glyphColor ?? Color("glyphButton", bundle: .module)
            self.backgroundTop = backgroundTop ?? Color("glyphButtonBackgroundTop", bundle: .module)
            self.backgroundBottom = backgroundBottom ?? Color("glyphButtonBackgroundBottom", bundle: .module)
            self.border = border ?? Color("glyphBorder", bundle: .module)
            self.disabledOverlay = disabledOverlay ?? Color("glyphDisabledOverlay", bundle: .module)
            self.waveOverlay = waveOverlay ?? Color("glyphWaveOverlay", bundle: .module)
        }
    }
    
    public init(iconName: String,
                state: Binding<ButtonState> = .constant(.enabled),
                size: Double = GlyphButton.size,
                borderWidth: Double = GlyphButton.borderWidth,
                innerPadding: Double = GlyphButton.innerPadding,
                colors: Colors = GlyphButton.colors,
                hasShadow: Bool = GlyphButton.hasShadow,
                hasHaptic: Bool = GlyphButton.hasHaptic,
                isAnimated: Bool = GlyphButton.isAnimated,
                isBlinking: Binding<Bool> = .constant(GlyphButton.isBlinking),
                action: @escaping () -> Void) {
        self.iconName = iconName
        self._state = state
        self.size = size
        self.borderWidth = borderWidth
        self.innerPadding = innerPadding
        self.colors = colors
        self.hasShadow = hasShadow
        self.hasHaptic = hasHaptic
        self.isAnimated = isAnimated
        self._isBlinking = isBlinking
        self.action = action
    }
    
    public var body: some View {
        Image(systemName: iconName)
            .font(.system(size: size, weight: .semibold, design: .rounded))
            .foregroundStyle(colors.glyphColor.opacity(state == .enabled ? 1 : 0.5))
            .opacity(state == .loading ? 0 : 1)
            .padding(innerPadding)
            .overlay {
                if state == .loading {
                    ProgressView()
                        .scaleEffect(size / 24)
                        .tint(colors.glyphColor)
                }
            }
            .background {
                Circle()
                    .stroke(colors.border, lineWidth: borderWidth)
                    .overlay {
                        ZStack {
                            RadialGradient(colors: [colors.backgroundTop, colors.backgroundBottom], center: UnitPoint(x: animate ? 0.5 : 0.5, y: animate ? 0.2 : 0.8), startRadius: 5, endRadius: 40)
                                .animation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true), value: animate)
                                .mask(Circle())
                                .onAppear { if isAnimated { animate = true } }

                            if isBlinking {
                                Circle()
                                    .fill(RadialGradient(colors: [colors.waveOverlay.opacity(0), colors.waveOverlay], center: .center, startRadius: 0, endRadius: innerPadding))
                                    .blendMode(.exclusion)
                                    .scaleEffect(animateBlink ? 10 : 0)
                                    .opacity(animateBlink ? 0 : 2)
                                    .mask(Circle())
                                    .animation(.easeIn(duration: 2.0).delay(1.0).repeatForever(autoreverses: false), value: animateBlink)
                                    .onAppear { animateBlink = true }
                                    .onDisappear { animateBlink = false }
                            }
                        }
                    }
                    .overlay {
                        if state == .disabled {
                            Circle()
                                .fill(colors.disabledOverlay)
                        }
                    }
                    .shadow(color: .black.opacity(hasShadow ? 0.2 : 0), radius: 1, y: 1)
            }
            .scaleEffect(animateBlink ? 1.3 : 1.0)
            .animation(isBlinking ? .timingCurve(1, 0, 1, 1, duration: 1.5).repeatForever(autoreverses: true) : .easeOut, value: animateBlink)
            .onTapGesture {
                if hasHaptic {
                    let hapticImpact = UIImpactFeedbackGenerator(style: .medium)
                    hapticImpact.impactOccurred()
                }
                
                action()
            }
            .disabled(state != .enabled)
    }
}

#Preview {
    GlyphButton(iconName: "paperplane.fill") {}
}
