//
//  GenericButtonDemo.swift
//  VisualKit-Sample
//
//  Created by Michel-André Chirita on 22/09/2024.
//

import SwiftUI
import VisualKit

struct GenericButtonDemo: View {
    
    @State var buttonState: GenericButton.ButtonState = .enabled
    @State var buttonTapped: Bool = false
    @State var text: String = "Adjustable"
    @State var cornerRadius: Double = 20
    @State var borderWidth: Double = 10
    @State var fontSize: Double = 16
    @State var relief: GenericButton.ReliefStyle = .none
    @State var haptic: Bool = true
    @State var animated: Bool = true

    var body: some View {
        ScrollView {
            VStack {
                Spacer()
                
                GenericButton("Default") {
                    print("Button tapped")
                }
                .padding(.horizontal, 40)
                
                GenericButton("Primary".uppercased(),
                              style: .primary(destructive: false),
                              state: $buttonState,
                              colors: someSpecificColors,
                              cornerRadius: 5,
                              borderWidth: 4,
                              fontSize: 20,
                              reliefStyle: .shadow,
                              hasHaptic: false,
                              isAnimated: false) {
                    print("Button tapped")
                }
                              .padding(.horizontal, 40)
                
                GenericButton("Primary destructive",
                              style: .primary(destructive: true),
                              state: $buttonState,
                              fontSize: 18) {
                    print("Button tapped")
                }
                              .padding(.horizontal, 40)
                
                GenericButton("Secondary",
                              style: .secondary(destructive: false),
                              state: $buttonState,
                              colors: GenericButton.Colors(secondaryButton: buttonTapped ? .green : nil, secondaryButtonText: buttonTapped ? .green : nil)) {
                    print("Button tapped")
                    buttonTapped = true
                }
                              .padding(.horizontal, 40)
                
                GenericButton("Secondary destructive",
                              style: .secondary(destructive: true),
                              state: $buttonState,
                              fontSize: 16) {
                    print("Button tapped")
                }
                              .padding(.horizontal, 40)
                
                GenericButton("Tertiary",
                              style: .tertiary(destructive: false),
                              state: $buttonState) {
                    print("Button tapped")
                }
                              .padding(.horizontal, 40)
                
                GenericButton("Tertiary destructive",
                              style: .tertiary(destructive: true),
                              state: $buttonState) {
                    print("Button tapped")
                }
                              .padding(.horizontal, 40)
                                
                Picker("Buttons state", selection: $buttonState) {
                    ForEach([GenericButton.ButtonState.disabled, GenericButton.ButtonState.loading, GenericButton.ButtonState.enabled], id: \.self) {
                        Text($0.name)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.vertical)

                VStack(spacing: 20) {
                    GenericButton(text,
                                  style: .primary(destructive: false),
                                  state: $buttonState,
                                  colors: relief == .shadow ? GenericButton.Colors(primaryButton: .clear, primaryButtonText: Color.primaryButtonText) : nil,
                                  cornerRadius: cornerRadius,
                                  borderWidth: borderWidth,
                                  fontSize: fontSize,
                                  reliefStyle: relief,
                                  hasHaptic: haptic,
                                  isAnimated: animated) {
                        print("Button tapped")
                    }
                                  .padding(.vertical)
                    
                    TextField(text: $text) {
                        Text("Title")
                    }
                    .textFieldStyle(.roundedBorder)
                    
                    HStack {
                        Text("Border width")
                        Spacer()
                        Slider(value: $borderWidth, in: (0...10.0), step: 1)
                            .containerRelativeFrame(.horizontal) { length, _ in length * 0.4 }
                        Text("\(Int(borderWidth))")
                            .frame(width: 25)
                    }
                    
                    HStack {
                        Text("Corner radius")
                        Spacer()
                        Slider(value: $cornerRadius, in: (0...30.0), step: 1)
                            .containerRelativeFrame(.horizontal) { length, _ in length * 0.4 }
                        Text("\(Int(cornerRadius))")
                            .frame(width: 25)
                    }
                    
                    HStack {
                        Text("Font size")
                        Spacer()
                        Slider(value: $fontSize, in: (5...60.0), step: 1)
                            .containerRelativeFrame(.horizontal) { length, _ in length * 0.4 }
                        Text("\(Int(fontSize))")
                            .frame(width: 25)
                    }
                    
                    HStack {
                        Text("Relief style")
                        Spacer()
                        Picker("", selection: $relief) {
                            ForEach([GenericButton.ReliefStyle.none, GenericButton.ReliefStyle.retro, GenericButton.ReliefStyle.shadow], id: \.self) {
                                Text($0.name)
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding(.vertical)
                    }
                    
                    HStack {
                        Text("Has haptic")
                        Spacer()
                        Toggle("", isOn: $haptic)
                    }
                    
                    HStack {
                        Text("Is animated")
                        Spacer()
                        Toggle("", isOn: $animated)
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(.gray).opacity(0.2))
                .padding()
                
                Spacer()
            }
            .onAppear {
                // Method 1
                // Configure once at app launch for global values
                GenericButton.colors = GenericButton.Colors(primaryButton: Color.primaryButton,
                                                            secondaryButton: Color.secondaryButton,
                                                            disabledButton: Color.disabledButton,
                                                            destructiveButton: .red,
                                                            primaryButtonText: Color.primaryButtonText,
                                                            secondaryButtonText: Color.primaryText,
                                                            tertiaryButtonText: Color.primaryText,
                                                            disabledButtonText: Color.disabledButtonText)
                GenericButton.cornerRadius = 20
                // Method 2
                // It's also possible to change values on a specific button, see the buttons configurations above
            }
            .padding()
            .navigationTitle("GenericButton")
        }
//        .defaultScrollAnchor(.bottom)
    }
    
    private let someSpecificColors = GenericButton
        .Colors(primaryButton: Color.primaryButton,
                primaryButtonText: Color.primaryButtonText)
}

#Preview {
    GenericButtonDemo()
}

private extension GenericButton.ButtonState {
    var name: String {
        switch self {
        case .enabled: "enabled"
        case .disabled: "disabled"
        case .loading: "loading"
        }
    }
}

private extension GenericButton.ReliefStyle {
    var name: String {
        switch self {
        case .none: "none"
        case .retro: "retro"
        case .shadow: "shadow"
        }
    }
}
