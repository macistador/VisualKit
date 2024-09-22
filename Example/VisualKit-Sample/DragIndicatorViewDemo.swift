//
//  DragIndicatorViewDemo.swift
//  VisualKit-Sample
//
//  Created by Michel-André Chirita on 22/09/2024.
//

import SwiftUI
import VisualKit

struct DragIndicatorViewDemo: View {
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 30)
                .fill(.blue)
                .overlay(alignment: .bottom) {
                    DragIndicatorView()
                        .padding(.bottom)
                }
            RoundedRectangle(cornerRadius: 30)
                .fill(.red)
        }
        .padding()
        .navigationTitle("DragIndicatorView")
    }
}

#Preview {
    DragIndicatorViewDemo()
}
