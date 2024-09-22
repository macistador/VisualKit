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
    
    public init(message: String, kind: Kind = .error) {
        self.message = message
        self.kind = kind
    }
    
    public var body: some View {
        Text(message.prefix(100))
            .bold()
            .foregroundStyle(kind.color)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(kind.color)
                    RoundedRectangle(cornerRadius: 20)
                        .fill(kind.color.opacity(0.3))
                        .padding(1)
                }
            }
    }
}

#Preview {
    MessageBannerView(message: "Unexpected error!")
    MessageBannerView(message: "Be warned", kind: .warning)
    MessageBannerView(message: "Something happened", kind: .info)
}
