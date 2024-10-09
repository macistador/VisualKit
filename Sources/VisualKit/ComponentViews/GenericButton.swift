//
//  SwiftUIView.swift
//  VisualKit
//
//  Created by Michel-André Chirita on 22/09/2024.
//

import SwiftUI

public struct GenericButton: View {
    
    // MARK: - Globlal configuration
    
    public static var colors: Colors = Colors()
    public static var cornerRadius: Double = 30.0
    public static var borderWidth: Double = 3.0
    public static var fontSize: (primary: Double, secondary: Double, tertiary: Double) = (primary: 24, secondary: 20, tertiary: 16)
    public static var reliefStyle: ReliefStyle = .none
    public static var isAnimated: Bool = true
    public static var hasHaptic: Bool = true

    // MARK: - Parameters
    
    public struct Colors {
        let primaryButton: Color
        let secondaryButton: Color
        let disabledButton: Color
        let destructiveButton: Color
        let primaryButtonBorder: Color
        let primaryButtonText: Color
        let secondaryButtonText: Color
        let tertiaryButtonText: Color
        let disabledButtonText: Color
        let gradient: [Color]
        
        public init(primaryButton: Color? = nil,
                    secondaryButton: Color? = nil,
                    disabledButton: Color? = nil,
                    destructiveButton: Color? = nil,
                    primaryButtonBorder: Color? = nil,
                    primaryButtonText: Color? = nil,
                    secondaryButtonText: Color? = nil,
                    tertiaryButtonText: Color? = nil,
                    disabledButtonText: Color? = nil,
                    gradient: [Color]? = nil) {
            self.primaryButton = primaryButton ?? Color("primaryButton", bundle: .module)
            self.secondaryButton = secondaryButton ?? Color("secondaryButton", bundle: .module)
            self.disabledButton = disabledButton ?? Color("disabledButton", bundle: .module)
            self.destructiveButton = destructiveButton ?? Color.red
            self.primaryButtonBorder = primaryButtonBorder ?? Color("primaryButtonBorder", bundle: .module)
            self.primaryButtonText = primaryButtonText ?? Color("primaryButtonText", bundle: .module)
            self.secondaryButtonText = secondaryButtonText ?? Color("secondaryButtonText", bundle: .module)
            self.tertiaryButtonText = tertiaryButtonText ?? Color("tertiaryButtonText", bundle: .module)
            self.disabledButtonText = disabledButtonText ?? Color("disabledButtonText", bundle: .module)
            self.gradient = gradient ?? [.pink, .purple, .cyan, .purple, .cyan, .pink]
        }
    }
    
    public enum ButtonState {
        case enabled
        case disabled
        case loading
    }
    
    public enum Style {
        case primary(destructive: Bool)
        case secondary(destructive: Bool)
        case tertiary(destructive: Bool)
        
        var minimumHeight: Double {
            switch self {
            case .primary: 65
            case .secondary: 65
            case .tertiary: 30
            }
        }
        
        var maximumHeight: Double {
            switch self {
            case .primary: 65
            case .secondary: 65
            case .tertiary: 45
            }
        }
        
        var hasReflief: Bool {
            switch self {
            case .primary: true
            case .secondary, .tertiary: false
            }
        }
        
        var fontSize: Double {
            switch self {
            case .primary: GenericButton.fontSize.primary
            case .secondary: GenericButton.fontSize.secondary
            case .tertiary: GenericButton.fontSize.tertiary
            }
        }
    }
    
    public enum ReliefStyle {
        case none
        case retro
        case shadow
    }
    
    // MARK: - View
    
    var title: String
    @Binding var state: ButtonState
    var style: Style
    let colors: Colors
    var cornerRadius: Double
    var borderWidth: Double
    var fontSize: Double
    var reliefStyle: ReliefStyle
    var isAnimated: Bool
    var hasHaptic: Bool
    var action: () -> Void
    @State private var animateTap: Bool = false
    @State private var animateColors: Bool = false

    public init(_ title: String,
                style: Style = .primary(destructive: false),
                state: Binding<ButtonState> = .constant(.enabled),
                colors: Colors? = nil,
                cornerRadius: Double = GenericButton.cornerRadius,
                borderWidth: Double = GenericButton.borderWidth,
                fontSize: Double? = nil,
                reliefStyle: ReliefStyle = GenericButton.reliefStyle,
                hasHaptic: Bool = GenericButton.hasHaptic,
                isAnimated: Bool = GenericButton.isAnimated,
                action: @escaping () -> Void) {
        self.title = title
        self.style = style
        self.cornerRadius = cornerRadius
        self.borderWidth = borderWidth
        self.fontSize = fontSize ?? style.fontSize
        self._state = state
        self.colors = colors ?? GenericButton.colors
        self.reliefStyle = reliefStyle
        self.isAnimated = isAnimated
        self.hasHaptic = hasHaptic
        self.action = action
    }
    
    public var body: some View {
        HStack {
            Spacer()
            Button {
                if isAnimated {
                    animateTap = true
                }
                
                if hasHaptic {
                    let hapticImpact = UIImpactFeedbackGenerator(style: .medium)
                    hapticImpact.impactOccurred()
                }
                
                action()
            } label: {
                ZStack {
                    if reliefStyle != .none, state == .enabled {
                        if reliefStyle == .retro {
                            ZStack {
                                if backgroundColor != .clear {
                                    RoundedRectangle(cornerRadius: cornerRadius)
                                        .stroke(state == .enabled ? borderColor : disabledBorderColor, lineWidth: borderWidth / 2)
                                }
                                RoundedRectangle(cornerRadius: cornerRadius)
                                    .fill(state == .enabled ? backgroundColor : disabledBackgroundColor)
                            }
                            .offset(y: 4 + borderWidth * 0.7)
                            .padding(1)
                        } else if reliefStyle == .shadow {
                            RoundedRectangle(cornerRadius: cornerRadius)
                                .fill(AngularGradient(colors: state == .enabled ? colors.gradient : [disabledBorderColor], center: .center, angle: .degrees(animateColors ? 360 : 0)))
                                .offset(y: 4 + borderWidth * 0.7)
                                .padding(.top, 10)
                                .opacity(0.5)
                                .scaleEffect(x: 0.8, y: animateTap ? 0.6 : 0.8)
                                .blur(radius: 20)
                                .animation(.bouncy(duration: 0.3), value: animateTap)
                                .animation(.linear(duration: isAnimated ? 4.0 : 0).repeatForever(autoreverses: false), value: animateColors && isAnimated)
                        }
                    }

                    ZStack {
                        if reliefStyle == .shadow {
                            RoundedRectangle(cornerRadius: cornerRadius)
                                .stroke(AngularGradient(colors: state == .enabled ? colors.gradient : [disabledBorderColor], center: .center, angle: .degrees(animateColors ? 360 : 0)), lineWidth: borderWidth)
                                .animation(.linear(duration: isAnimated ? 4.0 : 0).repeatForever(autoreverses: false), value: animateColors && isAnimated)
                                .onAppear {
                                    guard isAnimated else { return }
                                    animateColors = true
                                }
                            RoundedRectangle(cornerRadius: cornerRadius)
                                .fill(Material.regular)
                                .background(backgroundColor)
                                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))

                        } else {
                            RoundedRectangle(cornerRadius: cornerRadius)
                                .stroke(state == .enabled ? borderColor : disabledBorderColor, lineWidth: borderWidth)
                            RoundedRectangle(cornerRadius: cornerRadius)
                                .inset(by: borderWidth / 2)
                                .fill(state == .enabled ? backgroundColor : disabledBackgroundColor)
                        }
                    }
                    .overlay {
                        if state == .loading {
                            ProgressView()
                        }
                        else {
                            Text(title)
                                .font(.system(size: fontSize, weight: .bold))
                                .foregroundStyle(state == .enabled ? textColor : disabledTextColor)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                        }
                    }
                    .offset(y: (animateTap && style.hasReflief && reliefStyle != .none) ? 3 + borderWidth * 0.7 : 0)
                    .animation(.bouncy(duration: 0.3), value: animateTap)
                }
                .padding([.horizontal, .top])
            }
            .disabled(state != .enabled)
            .frame(minHeight: style.minimumHeight, maxHeight: style.maximumHeight)
//            .padding(.horizontal, 40)
            Spacer()
        }
    }
    
    private var backgroundColor: Color {
        switch style {
        case .primary(let isDestructive): isDestructive ? colors.destructiveButton : colors.primaryButton
        case .secondary: .clear
        case .tertiary: .clear
        }
    }
    
    private var disabledBackgroundColor: Color {
        switch style {
        case .primary: colors.disabledButton
        case .secondary: .clear
        case .tertiary: .clear
        }
    }
    
    private var borderColor: Color {
        switch style {
        case .primary: colors.primaryButtonBorder
        case .secondary(let isDestructive): isDestructive ? colors.destructiveButton : colors.secondaryButton
        case .tertiary: .clear
        }
    }
    
    private var disabledBorderColor: Color {
        switch style {
        case .primary: colors.disabledButtonText
        case .secondary: colors.disabledButton
        case .tertiary: .clear
        }
    }
    
    private var textColor: Color {
        switch style {
        case .primary: colors.primaryButtonText
        case .secondary(let isDestructive): isDestructive ? colors.destructiveButton : colors.secondaryButtonText
        case .tertiary(let isDestructive): isDestructive ? colors.destructiveButton : colors.tertiaryButtonText
        }
    }
    
    private var disabledTextColor: Color {
        switch style {
        case .primary: colors.disabledButtonText
        case .secondary: colors.disabledButton
        case .tertiary: colors.disabledButton
        }
    }
}

#Preview {
    Group {
        GenericButton("Go", state: .constant(.enabled), action: {})
            .padding(.horizontal, 40)
        GenericButton("Disabled", style: .primary(destructive: false), state: .constant(.disabled), cornerRadius: 4, borderWidth: 0, reliefStyle: .retro, action: {})
            .padding(.horizontal, 40)
        GenericButton("Destructive", style: .primary(destructive: true), state: .constant(.enabled), action: {})
            .padding(.horizontal, 40)
        GenericButton("Secondary", style: .secondary(destructive: false), state: .constant(.enabled), action: {})
            .padding(.horizontal, 40)
        GenericButton("Secondary with long text", style: .secondary(destructive: true), state: .constant(.enabled), action: {})
            .padding(.horizontal, 40)
        GenericButton("Tertiary", style: .tertiary(destructive: false), state: .constant(.enabled), action: {})
            .padding(.horizontal, 40)
        GenericButton("Tertiary destructive", style: .tertiary(destructive: true), state: .constant(.enabled), action: {})
            .padding(.horizontal, 40)
    }
}

