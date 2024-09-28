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
                TagView(name: "Feudal System")
                TagView(name: "Medieval Warfare")
                TagView(name: "Castles")
                TagView(name: "Daily")
                TagView(name: "Health")
                TagView(name: "Crusades")
                TagView(name: "Royalty")
                TagView(name: "Religious Influences")
                TagView(name: "Literature")
                TagView(name: "Regional")
            }
//            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    if #available(iOS 17.0, *) {
        ChipsStackDemo()
    } else {
        // Fallback on earlier versions
    }
}
