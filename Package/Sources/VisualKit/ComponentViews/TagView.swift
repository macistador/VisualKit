//
//  SwiftUIView.swift
//  VisualKit
//
//  Created by Michel-André Chirita on 28/09/2024.
//

import SwiftUI

public struct TagView: View {
    
    var name: String
    var textSize: Double
    var borderColor: Color
    var backgroundColor: Color
    var textColor: Color
    var lineWidth: Double
    @Binding var deletable: Bool
    
    public init(name: String, textSize: Double = 14, borderColor: Color = .blue, backgroundColor: Color = .clear, textColor: Color = .blue, lineWidth: Double = 1, deletable: Binding<Bool> = .constant(false)) {
        self.name = name
        self.textSize = textSize
        self.borderColor = borderColor
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.lineWidth = lineWidth
        self._deletable = deletable
    }
    
    public var body: some View {
        HStack {
            Text(name)
                .font(.system(size: textSize, weight: .regular))
                .foregroundStyle(textColor)
            if deletable {
                Image(systemName: "xmark")
                    .font(.system(size: textSize, weight: .medium))
                    .foregroundStyle(textColor)
            }
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 10)
        .background(
            ZStack {
                Capsule()
                    .fill(backgroundColor)
                Capsule()
                    .stroke(borderColor, lineWidth: lineWidth)
            }
        )
        .padding(.vertical, 1)
    }
}

#Preview {
    TagView(name: "Tag")
}
