//
//  SwiftUIView.swift
//  VisualKit
//
//  Created by Michel-André Chirita on 25/09/2024.
//

import SwiftUI

public struct TitleView: View {

    var title: String
    var titleSize: Double
    var subtitle: String?
    var subtitleSize: Double
    var color: Color
    var alignment: HorizontalAlignment
    var effect: Bool
    var customFont: String?
    @State private var animate: Bool = false

    public init(title: String, titleSize: Double = 35, subtitle: String? = nil, subtitleSize: Double = 16, color: Color? = nil, alignment: HorizontalAlignment = .center, effect: Bool = true, customFont: String? = nil) {
        self.title = title
        self.titleSize = titleSize
        self.subtitle = subtitle
        self.subtitleSize = subtitleSize
        self.color = color ?? Color("primaryText", bundle: .module)
        self.alignment = alignment
        self.effect = effect
        self.customFont = customFont
    }
    
    public var body: some View {
        VStack(alignment: alignment, spacing: 5) {
            Text(title)
                .font(font)
                .rotationEffect(.degrees(effect ? -3 : 0))
                .textCase(.uppercase)
                .multilineTextAlignment(textAlignment)
                .foregroundStyle(color)
                .overlay {
                    if effect {
                        RadialGradient(colors: [color, color.opacity(0.5)], center: UnitPoint(x: animate ? 0.3 : 0.8, y: animate ? 0.4 : 0.7), startRadius: 20, endRadius: 200)
                            .animation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true), value: animate)
                            .mask {
                                Text(title)
                                    .textCase(.uppercase)
                                    .font(font)
                                    .multilineTextAlignment(textAlignment)
                                    .foregroundStyle(color)
                            }
                    }
                }
            if let subtitle {
                Text(subtitle)
                    .font(.system(size: subtitleSize, weight: .bold, design: .rounded))
                    .multilineTextAlignment(textAlignment)
                    .foregroundStyle(color)
            }
        }
        .padding()
        .onAppear {
            animate = true
        }
    }
    
    private var font: Font {
        if let customFont {
            Font.custom(customFont, size: titleSize)
        } else {
            Font.system(size: /* effect ?*/ titleSize /*: titleSize - 10*/, weight: .black, design: .rounded)
        }
    }
    
    private var textAlignment: TextAlignment {
        switch alignment {
        case .leading: .leading
        case .trailing: .trailing
        default: .center
        }
    }
}

#Preview {
    TitleView(title: "Title", subtitle: "subtitle")
}
