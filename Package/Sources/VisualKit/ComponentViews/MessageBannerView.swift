//
//  SwiftUIView.swift
//  VisualKit
//
//  Created by Michel-André Chirita on 22/09/2024.
//

import SwiftUI

public struct MessageBannerView: View {
    
    public enum Kind {
        case info
        case warning
        case error
        
        var color: Color {
            switch self {
            case .info: .gray
            case .warning: .orange
            case .error: .red
            }
        }
    }
    
    let message: String
    let kind: Kind
    let cornerRadius: Double
    let borderWidth: Double

    public init(message: String, kind: Kind = .error, cornerRadius: Double = 20, borderWidth: Double = 1) {
        self.message = message
        self.kind = kind
        self.cornerRadius = cornerRadius
        self.borderWidth = borderWidth
    }
    
    public var body: some View {
        Text(message.prefix(100))
            .bold()
            .foregroundStyle(kind.color)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background {
                ZStack {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(kind.color, lineWidth: borderWidth)
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .inset(by: borderWidth / 2)
                        .fill(kind.color.opacity(0.3))
                }
            }
    }
}

#Preview {
    MessageBannerView(message: "Unexpected error!")
    MessageBannerView(message: "Be warned", kind: .warning)
    MessageBannerView(message: "Something happened", kind: .info)
}
