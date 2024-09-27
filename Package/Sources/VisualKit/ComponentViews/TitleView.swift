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
    var subtitleSize: Double = 16
    var alignment: HorizontalAlignment = .center
    var enabled: Bool = true
    var customFont: String? = nil
    var color: Color = .red
    @State private var animate: Bool = false

    public init(title: String, titleSize: Double = 35, subtitle: String? = nil, subtitleSize: Double = 16, alignment: HorizontalAlignment = .center, enabled: Bool = true, customFont: String? = nil) {
        self.title = title
        self.titleSize = titleSize
        self.subtitle = subtitle
        self.subtitleSize = subtitleSize
        self.alignment = alignment
        self.enabled = enabled
        self.customFont = customFont
    }
    
    public var body: some View {
        VStack(alignment: alignment, spacing: 5) {
            Text(title)
                .font(font)
                .rotationEffect(.degrees(-3))
                .textCase(.uppercase)
                .multilineTextAlignment(textAlignment)
//                .lineSpacing(-20)
                .foregroundStyle(.tertiary)
                .overlay {
                    if enabled {
                        RadialGradient(colors: [color, color.opacity(0.5)], center: UnitPoint(x: animate ? 0.3 : 0.8, y: animate ? 0.4 : 0.7), startRadius: 20, endRadius: 200)
                            .animation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true), value: animate)
                            .mask {
                                Text(title)
                                    .textCase(.uppercase)
                                    .font(font)
                                    .multilineTextAlignment(textAlignment)
//                                    .lineSpacing(-20)
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
            Font.system(size: enabled ? titleSize : titleSize - 10, weight: .black, design: .rounded)
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
