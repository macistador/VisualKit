//
//  SwiftUIView.swift
//  VisualKit
//
//  Created by Michel-André Chirita on 22/09/2024.
//

import SwiftUI

public struct DragIndicatorView: View {
    
    let color: Color
    
    public init(color: Color = Color(red: 217/255, green: 217/255, blue: 217/255)) {
        self.color = color
    }
    
    public var body: some View {
        HStack {
            Spacer()
            Capsule()
                .fill(color)
                .frame(width: 78, height: 6)
            Spacer()
        }
    }
}

#Preview {
    DragIndicatorView()
}
