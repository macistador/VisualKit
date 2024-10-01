//
//  SwiftUIView.swift
//  VisualKit
//
//  Created by Michel-André Chirita on 01/10/2024.
//

import SwiftUI

public struct DecorationsLinesView: View {
    
    public init() {}
    
    public var body: some View {
        VStack {
            ForEach(0...80, id: \.self) { _ in
                DecoLine()
                    .rotationEffect(.degrees(-31))
            }
        }
    }
}

private struct DecoLine: View {
    var items: [DecoLineItemValue] = (0...30).map{ _ in DecoLineItemValue() }
    @State private var display: Bool = false
    
    var body: some View {
        HStack {
            ForEach(items, id: \.self) { item in
                DecoLineItem(width: item.lenght)
            }
        }
        .offset(x: display ? CGFloat((-100..<100).randomElement() ?? 0) : 0, y: 0)
        .onAppear {
            withAnimation(.easeInOut(duration: CGFloat((3..<6).randomElement() ?? 0)).repeatForever(autoreverses: true)) {
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
    let width: Double
    var body: some View {
        RoundedRectangle(cornerRadius: 13, style: .continuous)
            .foregroundColor(.white)
            .opacity(0.03)
            .frame(width: width, height: 13)
    }
}

#Preview {
    DecorationsLinesView()
        .background(Color.blue)
}
