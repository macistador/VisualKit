//
//  SwiftUIView.swift
//  VisualKit
//
//  Created by Michel-André Chirita on 01/10/2024.
//

import SwiftUI

struct DecorationsLinesView: View {
    
    private let color: Color
    private let speedMultiplier: Double

    init(color: Color = .white, speedMultiplier: Double = 1.0) {
        self.color = color
        self.speedMultiplier = speedMultiplier
    }
    
    var body: some View {
        VStack {
            ForEach(0...80, id: \.self) { _ in
                DecoLine(color: color, speedMultiplier: speedMultiplier)
                    .rotationEffect(.degrees(-31))
            }
        }
    }
}

private struct DecoLine: View {
    
    let color: Color
    let speedMultiplier: Double
    var items: [DecoLineItemValue] = (0...30).map{ _ in DecoLineItemValue() }
    @State private var display: Bool = false
    
    var body: some View {
        HStack {
            ForEach(items, id: \.self) { item in
                DecoLineItem(color: color, width: item.lenght)
            }
        }
        .offset(x: display ? CGFloat((-100..<100).randomElement() ?? 0) : 0, y: 0)
        .onAppear {
            withAnimation(.easeInOut(duration: CGFloat((3..<6).randomElement() ?? 0) / speedMultiplier).repeatForever(autoreverses: true)) {
                display = true
            }
        }
    }
}

private struct DecoLineItemValue: Identifiable, Hashable {
    var id: UUID = UUID()
    var lenght: Double = [140, 60, 20, 320].randomElement()!
}

private struct DecoLineItem: View {
    
    let color: Color
    let width: Double
    var body: some View {
        RoundedRectangle(cornerRadius: 13, style: .continuous)
            .foregroundColor(color)
            .opacity(0.03)
            .frame(width: width, height: 13)
    }
}

#Preview {
    DecorationsLinesView()
        .background(Color.blue)
}
