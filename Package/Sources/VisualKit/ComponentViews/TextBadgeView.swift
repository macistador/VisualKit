//
//  SwiftUIView.swift
//  VisualKit
//
//  Created by Michel-André Chirita on 22/09/2024.
//

import SwiftUI

public struct TextBadgeView: View {
    
    let text: String
    let color: ColorSet
    let borderColor: Color
    let borderWidth: Double
    let cornerRadius: Double
    let fontSize: Double
    let minWidth: Double

    public init(text: String, color: ColorSet, borderColor: Color? = nil, borderWidth: Double = 3, cornerRadius: Double = 10, fontSize: Double = 16, minWidth: Double = 140) {
        self.text = text
        self.color = color
        self.borderColor = borderColor ?? Color("textBadgeBorder", bundle: .module)
        self.borderWidth = borderWidth
        self.cornerRadius = cornerRadius
        self.fontSize = fontSize
        self.minWidth = minWidth
    }
    
    public var body: some View {
        Text(text)
            .font(.system(size: fontSize, weight: .black, design: .rounded))
//            .minimumScaleFactor(0.5)
            .foregroundStyle(.black)
            .padding(.horizontal, borderWidth * 3)
            .padding(.vertical, borderWidth * 0.6)
            .frame(minWidth: minWidth)
            .background {
                ZStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(borderColor, lineWidth: borderWidth)
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(borderColor)
                            .padding(borderWidth / 2)
                    }
                    .offset(x: borderWidth / 3, y: borderWidth / 3)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(borderColor, lineWidth: borderWidth)
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(color.color)
                            .padding(borderWidth / 2)
                    }
                }
            }
    }
    
    public enum ColorSet {
        case yellow
        case red
        case green
        case blue
        case pink
        case custom(Color)
        
        var color: Color {
            switch self {
            case .yellow: Color(red: 255/255, green: 236/255, blue: 129/255)
            case .red: Color(red: 255/255, green: 129/255, blue: 129/255)
            case .green: Color(red: 154/255, green: 255/255, blue: 129/255)
            case .blue: Color(red: 129/255, green: 236/255, blue: 255/255)
            case .pink: Color(red: 230/255, green: 129/255, blue: 255/255)
            case .custom(let color): color
            }
        }
    }
}

#Preview {
    TextBadgeView(text: "Make friends", color: .yellow)
}

