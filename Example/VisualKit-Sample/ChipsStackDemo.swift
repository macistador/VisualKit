//
//  ChipsStackDemo.swift
//  VisualKit-Sample
//
//  Created by Michel-André Chirita on 25/09/2024.
//

import SwiftUI
import VisualKit

struct ChipsStackDemo: View {
    var body: some View {
            ChipsStack {
                TagView(name: "Feudal System", selected: false, deletable: false)
                TagView(name: "Medieval Warfare", selected: false, deletable: false)
                TagView(name: "Castles", selected: false, deletable: false)
                TagView(name: "Daily", selected: false, deletable: false)
                TagView(name: "Health", selected: false, deletable: false)
                TagView(name: "Crusades", selected: false, deletable: false)
                TagView(name: "Royalty", selected: false, deletable: false)
                TagView(name: "Religious Influences", selected: false, deletable: false)
                TagView(name: "Literature", selected: false, deletable: false)
                TagView(name: "Regional", selected: false, deletable: false)
            }
    }
}

@available(iOS 17.0, *)
struct TagView: View {
    
    var name: String
    var selected: Bool
    var deletable: Bool
    
    var body: some View {
        HStack {
            Text(name)
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(selected ? .black : .white)
            if deletable {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(selected ? .black : .white)
            }
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 10)
        .background(
            Capsule()
                .fill(selected ? .blue : .clear)
                .stroke(selected ? .clear : .blue, lineWidth: 1)
        )
        .padding(.vertical, 1)
    }
}

#Preview {
    ChipsStackDemo()
}
