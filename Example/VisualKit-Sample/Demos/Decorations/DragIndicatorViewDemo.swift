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
        ScrollView {
            VStack {
                RoundedRectangle(cornerRadius: 30)
                    .fill(.gray)
                    .frame(height: 600)
                    .overlay(alignment: .bottom) {
                        DragIndicatorView(color: .red)
                            .padding(.bottom)
                    }
                RoundedRectangle(cornerRadius: 30)
                    .fill(.gray)
                    .frame(height: 600)
            }
            .padding()
        }
        .navigationTitle("DragIndicatorView")
    }
}

#Preview {
    DragIndicatorViewDemo()
}
