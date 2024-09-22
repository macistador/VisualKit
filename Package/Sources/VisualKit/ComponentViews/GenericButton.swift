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
    public static var reliefEffect: Bool = true
    public static var animated: Bool = true
    public static var haptic: Bool = true

    // MARK: - Parameters
    
    public struct Colors {
        let primaryButton: Color
        let secondaryButton: Color
        let disabledButton: Color
        let destructiveButton: Color
        let primaryButtonText: Color
        let secondaryButtonText: Color
        let tertiaryButtonText: Color
        let disabledButtonText: Color
        
        public init(primaryButton: Color? = nil, secondaryButton: Color? = nil, disabledButton: Color? = nil, destructiveButton: Color? = nil, primaryButtonText: Color? = nil, secondaryButtonText: Color? = nil, tertiaryButtonText: Color? = nil, disabledButtonText: Color? = nil) {
            self.primaryButton = primaryButton ?? Color("primaryButton", bundle: .module)
            self.secondaryButton = secondaryButton ?? Color("secondaryButton", bundle: .module)
            self.disabledButton = disabledButton ?? Color("disabledButton", bundle: .module)
            self.destructiveButton = destructiveButton ?? Color.red
            self.primaryButtonText = primaryButtonText ?? Color("primaryButtonText", bundle: .module)
            self.secondaryButtonText = secondaryButtonText ?? Color("secondaryButtonText", bundle: .module)
            self.tertiaryButtonText = tertiaryButtonText ?? Color("tertiaryButtonText", bundle: .module)
            self.disabledButtonText = disabledButtonText ?? Color("disabledButtonText", bundle: .module)
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
    
    // MARK: - View
    
    var title: String
    @Binding var state: ButtonState
    var style: Style
    let colors: Colors
    var cornerRadius: Double
    var borderWidth: Double
    var fontSize: Double
    var reliefEffect: Bool
    var animated: Bool
    var haptic: Bool
    var action: () -> Void
    @State private var animate: Bool = false

    public init(title: String, style: Style = .primary(destructive: false), state: Binding<ButtonState> = .constant(.enabled), colors: Colors = GenericButton.colors, cornerRadius: Double = GenericButton.cornerRadius, borderWidth: Double = GenericButton.borderWidth, fontSize: Double? = nil, reliefEffect: Bool = GenericButton.reliefEffect, haptic: Bool = GenericButton.haptic, animated: Bool = GenericButton.animated, action: @escaping () -> Void) {
        self.title = title
        self.style = style
        self.cornerRadius = cornerRadius
        self.borderWidth = borderWidth
        self.fontSize = fontSize ?? style.fontSize
        self._state = state
        self.colors = colors
        self.reliefEffect = reliefEffect
        self.animated = animated
        self.haptic = haptic
        self.action = action
    }
    
    public var body: some View {
        HStack {
            Spacer()
            Button {
                action()
                
                if animated {
                    withAnimation(.bouncy(duration: 0.3)) {
                        animate = true
                    }
                }
                
                if haptic {
                    let hapticImpact = UIImpactFeedbackGenerator(style: .medium)
                    hapticImpact.impactOccurred()
                }
            } label: {
                ZStack {
                    if reliefEffect, state == .enabled {
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
                    }

                    ZStack {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke( state == .enabled ? borderColor : disabledBorderColor, lineWidth: borderWidth)
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .inset(by: borderWidth / 2)
                            .fill(state == .enabled ? backgroundColor : disabledBackgroundColor)
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
                    .offset(y: (animate && style.hasReflief && reliefEffect) ? 3 + borderWidth * 0.7 : 0)
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
        case .primary: .black
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
        GenericButton(title: "Go", state: .constant(.enabled), action: {})
            .padding(.horizontal, 40)
        GenericButton(title: "Disabled", style: .primary(destructive: false), state: .constant(.disabled), cornerRadius: 4, borderWidth: 0, reliefEffect: false, action: {})
            .padding(.horizontal, 40)
        GenericButton(title: "Destructive", style: .primary(destructive: true), state: .constant(.enabled), action: {})
            .padding(.horizontal, 40)
        GenericButton(title: "Secondary", style: .secondary(destructive: false), state: .constant(.enabled), action: {})
            .padding(.horizontal, 40)
        GenericButton(title: "Secondary with long text", style: .secondary(destructive: true), state: .constant(.enabled), action: {})
            .padding(.horizontal, 40)
        GenericButton(title: "Tertiary", style: .tertiary(destructive: false), state: .constant(.enabled), action: {})
            .padding(.horizontal, 40)
        GenericButton(title: "Tertiary destructive", style: .tertiary(destructive: true), state: .constant(.enabled), action: {})
            .padding(.horizontal, 40)
    }
}

