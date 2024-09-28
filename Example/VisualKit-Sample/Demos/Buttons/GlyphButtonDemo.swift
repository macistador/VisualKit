//
//  GlyphButtonDemo.swift
//  VisualKit-Sample
//
//  Created by Michel-André Chirita on 28/09/2024.
//

import SwiftUI
import VisualKit

struct GlyphButtonDemo: View {
    
    @State var buttonState: GlyphButton.ButtonState = .enabled
    @State var colors: GlyphButton.Colors = .init()
    @State var size: Double = 50
    @State var innerPadding: Double = 24
    @State var borderWidth: Double = 4
    @State var hasHaptic: Bool = true
    @State var hasShadow: Bool = true
    @State var isAnimated: Bool = true
    @State var isBlinking: Bool = false

    var body: some View {
        ScrollView {
            VStack() {
                HStack(spacing: 40) {
                    GlyphButton(iconName: "arrow.left",
                                state: $buttonState,
                                size: 26,
                                borderWidth: 3,
                                innerPadding: 12,
                                colors: GlyphButton.Colors(backgroundTop: .white,
                                                           backgroundBottom: .white),
                                isAnimated: false,
                                isBlinking: $isBlinking) {
                        print("Tap")
                    }
                    
                    GlyphButton(iconName: "arrow.up", state: $buttonState, isBlinking: $isBlinking) {
                        print("Tap")
                    }
                    
                    GlyphButton(iconName: "ellipsis",
                                state: $buttonState,
                                size: 22,
                                borderWidth: 0,
                                colors: GlyphButton.Colors(backgroundTop: .white,
                                                           backgroundBottom: .white,
                                                           border: .clear),
                                hasShadow: false,
                                isBlinking: $isBlinking) {
                        print("Tap")
                    }
                }
                
                Picker("Buttons state", selection: $buttonState) {
                    ForEach([GlyphButton.ButtonState.disabled, GlyphButton.ButtonState.loading, GlyphButton.ButtonState.enabled], id: \.self) {
                        Text($0.name)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.vertical)
                
                VStack(spacing: 20) {
                    GlyphButton(iconName: "ellipsis",
                                state: $buttonState,
                                size: size,
                                borderWidth: borderWidth,
                                innerPadding: innerPadding,
                                colors: colors,
                                hasShadow: hasShadow,
                                hasHaptic: hasHaptic,
                                isAnimated: isAnimated,
                                isBlinking: $isBlinking) {
                        print("Tap")
                    }
                                .padding(.vertical)
                    
                    HStack {
                        Text("Colors")
                        Spacer()
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(.black)
                            .padding(2)
                            .frame(width: 40, height: 40)
                            .clipShape(.rect)
                            .onTapGesture {
                                colors = .init(glyphColor: .black, backgroundTop: .clear, backgroundBottom: .clear, border: .black)
                            }
                        RoundedRectangle(cornerRadius: 4)
                            .fill(.black)
                            .frame(width: 40, height: 40)
                            .onTapGesture {
                                colors = .init(glyphColor: .white, backgroundTop: .black, backgroundBottom: .black, border: .white)
                            }
                        RoundedRectangle(cornerRadius: 4)
                            .fill(LinearGradient(colors: [.pink, .orange], startPoint: .top, endPoint: .bottom))
                            .frame(width: 40, height: 40)
                            .onTapGesture {
                                colors = .init(glyphColor: .white, backgroundTop: .pink, backgroundBottom: .orange, border: .yellow)
                            }
                    }
                    
                    HStack {
                        Text("Size")
                        Spacer()
                        Slider(value: $size, in: (5...60.0), step: 1)
                            .containerRelativeFrame(.horizontal) { length, _ in length * 0.4 }
                        Text("\(Int(size))")
                            .frame(width: 25)
                    }
                    
                    HStack {
                        Text("Inner padding")
                        Spacer()
                        Slider(value: $innerPadding, in: (0...40.0), step: 1)
                            .containerRelativeFrame(.horizontal) { length, _ in length * 0.4 }
                        Text("\(Int(innerPadding))")
                            .frame(width: 25)
                    }
                    
                    HStack {
                        Text("Border width")
                        Spacer()
                        Slider(value: $borderWidth, in: (0...10.0), step: 1)
                            .containerRelativeFrame(.horizontal) { length, _ in length * 0.4 }
                        Text("\(Int(borderWidth))")
                            .frame(width: 25)
                    }
                    
                    HStack {
                        Text("Has shadow")
                        Spacer()
                        Toggle("", isOn: $hasShadow)
                    }
                    
                    HStack {
                        Text("Has haptic")
                        Spacer()
                        Toggle("", isOn: $hasHaptic)
                    }
                    
                    HStack {
                        Text("Is animated")
                        Spacer()
                        Toggle("", isOn: $isAnimated)
                    }
                    
                    HStack {
                        Text("Is blinking")
                        Spacer()
                        Toggle("", isOn: $isBlinking)
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(.gray).opacity(0.2))
                .padding()
            }
        }
        .navigationTitle("GlyphButton")
        .onAppear {
            // Method 1
            // Configure once at app launch for global values
//            GlyphButton.colors = GlyphButton.Colors(glyphColor: .red,
//                                                    backgroundTop: .blue,
//                                                    backgroundBottom: .green,
//                                                    border: .yellow)
//            GlyphButton.size = 20
            
            // Method 2
            // It's also possible to change values on a specific button, see the buttons configurations above
        }
    }
}

#Preview {
    GlyphButtonDemo()
}

private extension GlyphButton.ButtonState {
    var name: String {
        switch self {
        case .enabled: "enabled"
        case .disabled: "disabled"
        case .loading: "loading"
        }
    }
}
