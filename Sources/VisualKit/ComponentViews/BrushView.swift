//
//  SwiftUIView.swift
//  VisualKit
//
//  Created by Michel-André Chirita on 22/09/2024.
//

import SwiftUI

public struct BrushView: View {
    
    @Binding var offsetWidth: Double
    @State private var privateOffsetWidth: Double = 0
    @State private var totalWidth: Double = 100
    @State private var extraWidth: Double = 50
    let height: Double
    
    public init(offsetWidth: Binding<Double>, height: Double = 60) {
        self._offsetWidth = offsetWidth
        self.height = height
    }
    
    public var body: some View {
        Rectangle()
            .fill(.clear)
            .background {
                HStack {
                    Spacer()
                    Image(.brush)
                        .resizable()
                        .frame(width: totalWidth, height: height)
                        .foregroundStyle(LinearGradient(colors: [Color.pink, Color.purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .mask {
                            HStack(spacing: 0) {
                                Rectangle()
                                    .frame(width: extraWidth + privateOffsetWidth, height: height)
                                Image(.brushPart)
                                    .resizable()
                                    .frame(width: 50, height: height)
                                Spacer()
                            }
                        }
                    Spacer()
                }
            }
            .onChange(of: offsetWidth) { newValue in
                animate(to: newValue)
            }
    }
    
    func animate(to offset: Double) {
        withAnimation(.bouncy(duration: 0.5)) {
            self.privateOffsetWidth = offset
            self.totalWidth = offset + 100
        }
    }
}

#Preview {
    BrushView(offsetWidth: .constant(20))
}
