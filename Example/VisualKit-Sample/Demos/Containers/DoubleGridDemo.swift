//
//  DoubleGridDemo.swift
//  VisualKit-Sample
//
//  Created by Michel-André Chirita on 25/09/2024.
//

import SwiftUI
import VisualKit

struct DoubleGridDemo: View {
    
    struct Item: Identifiable {
        public let id: String = UUID().uuidString
        public let color: Color = [Color.gray, Color.green, Color.red, Color.yellow, Color.pink, Color.purple, Color.blue, Color.cyan, Color.brown, Color.indigo, Color.mint, Color.teal, Color.orange].randomElement()!
    }
    
    private let items = [Item(), Item(), Item(), Item(), Item(), Item(), Item(), Item(), Item(), Item(), Item(), Item(), Item(), Item(), Item(), Item(), Item(), Item(), Item(), Item(), Item(), Item(), Item(), Item(), Item(), Item(), Item(), Item(), Item(), Item(), Item(), Item(), Item(), Item(), Item(), Item(), Item(), Item(), Item(), Item(), Item(), Item(), Item(), Item(), Item(), Item(), Item(), Item(), Item()]
    @State private var layoutIsTop: Bool = true

    var body: some View {
        /// Simplest version
//        DoubleGrid(items: items) { item in
//            Cell(item: item)
//        } miniCell: {
//            Cell(item: item)
//        }

        /// With all parameters
        DoubleGrid(items: items,
                   layout: layoutIsTop ? .top : .bottom,
                   cellHighlight: .stroke(color: .red, cornerRadius: 20),
                   mainGridBackgroundColor: .black,
                   draggableGridBackgroundColor: Color(white: 0.2)) { item in
            Cell(item: item, showText: true)
                .onTapGesture {
                    layoutIsTop.toggle()
                }
        } miniCell: { item in
            Cell(item: item, showText: false)
        }
        .ignoresSafeArea(edges: .bottom)
        .navigationTitle("DoubleGrid")
    }
}

private struct Cell: View {
    let item: DoubleGridDemo.Item
    let showText: Bool
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(item.color)
            .aspectRatio(0.7, contentMode: .fit)
            .overlay {
                if showText {
                    Text("Switch layout")
                        .bold()
                }
            }
    }
}

#Preview {
    DoubleGridDemo()
}
