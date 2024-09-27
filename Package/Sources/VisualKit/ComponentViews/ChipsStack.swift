//
//  SwiftUIView.swift
//  VisualKit
//
//  Created by Michel-André Chirita on 25/09/2024.
//

import SwiftUI

@available(iOS 16.0, *)
public struct ChipsStack: Layout {
    
    private let spacing: CGFloat
    
    public init(spacing: CGFloat = 8) {
        self.spacing = spacing
    }
    
    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let sizes = subviews.map { $0.sizeThatFits(proposal) }
        let maxViewHeight = sizes.map { $0.height }.max() ?? 0
        var currentRowWidth: CGFloat = 0
        var totalHeight: CGFloat = maxViewHeight
        var totalWidth: CGFloat = 0
        
        for size in sizes {
            if currentRowWidth + spacing + size.width > proposal.width ?? 0 {
                totalHeight += spacing + maxViewHeight
                currentRowWidth = size.width
            } else {
                currentRowWidth += spacing + size.width
            }
            totalWidth = max(totalWidth, currentRowWidth)
        }
        return CGSize(width: totalWidth, height: totalHeight)
    }
    
    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let sizes = subviews.map { $0.sizeThatFits(proposal) }
        let maxViewHeight = sizes.map { $0.height }.max() ?? 0
        var point = CGPoint(x: bounds.minX, y: bounds.minY)
        for index in subviews.indices {
            if point.x + sizes[index].width > bounds.maxX {
                point.x = bounds.minX
                point.y += maxViewHeight + spacing
            }
            subviews[index].place(at: point, proposal: ProposedViewSize(sizes[index]))
            point.x += sizes[index].width + spacing
        }
    }
}

@available(iOS 17.0, *)
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
//            .frame(maxWidth: .infinity, alignment: .leading)
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
    if #available(iOS 17.0, *) {
        ChipsStackDemo()
    } else {
        // Fallback on earlier versions
    }
}
