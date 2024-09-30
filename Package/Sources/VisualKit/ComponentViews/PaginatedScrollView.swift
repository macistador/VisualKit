//
//  SwiftUIView.swift
//  VisualKit
//
//  Created by Michel-André Chirita on 29/09/2024.
//

import SwiftUI

/*
 TODO:
 - gérer axe horizontal
 */

@available(iOS 17.0, *)
public struct PaginatedScrollView<Content: View, Item: Identifiable>: View {
    
    @State var items: [Item]
    @Binding var scrollOffset: Double
    @Binding var screenScrollPercent: Double
    let cellsInsets: EdgeInsets
    let cellsSpacing: Double
    @ViewBuilder var cell: (_ item: Item, _ visibilityPercent: Double)->Content
    @State private var scrollPageHeight = 0.0
    
    public init(items: [Item],
         scrollOffset: Binding<Double>,
         screenScrollPercent: Binding<Double>,
         cellsInsets: EdgeInsets = .init(top: 20,
                                         leading: 0,
                                         bottom: 20,
                                         trailing: 0),
         cellsSpacing: Double = 40.0,
         @ViewBuilder cell: @escaping (_ item: Item, _ visibilityPercent: Double)->Content) {
        self.items = items
        self._scrollOffset = scrollOffset
        self._screenScrollPercent = screenScrollPercent
        self.cellsInsets = cellsInsets
        self.cellsSpacing = cellsSpacing
        self.cell = cell
    }
    
    public var body: some View {
        GeometryReader { containerGeometry in
            if #available(iOS 17, *) {
                ScrollView(showsIndicators: false) {
                    ZStack {
                        scrollReader(with: containerGeometry)
                        scrollContent(with: containerGeometry)
                    }
                }
                .scrollTargetBehavior(.viewAligned(limitBehavior: .always))
            } else {
                ScrollView(showsIndicators: false) {
                    ZStack {
                        scrollReader(with: containerGeometry)
                        scrollContent(with: containerGeometry)
                    }
                }
                .scrollTargetBehavior(.viewAligned)
            }
        }
    }
    
    @ViewBuilder
    private func scrollReader(with containerGeometry: GeometryProxy) -> some View {
        GeometryReader { proxy in
            let offset = proxy.frame(in: .named("scroll")).minY
            Color.clear
                .preference(key: ScrollOffsetKey.self, value: offset)
        }
        .padding(.zero)
        .onPreferenceChange(ScrollOffsetKey.self) { value in
            scrollOffset = value
            let initialOffset = containerGeometry.safeAreaInsets.top
            let scrollPageOffset = (initialOffset - value).truncatingRemainder(dividingBy: scrollPageHeight)
            screenScrollPercent = scrollPageHeight == 0 ? 0 : scrollPageOffset / scrollPageHeight
        }
        .preference(key: ViewHeightKey.self, value: containerGeometry.frame(in: .global).height)
        .onPreferenceChange(ViewHeightKey.self) { value in
          scrollPageHeight = value
        }
    }
    
    @ViewBuilder
    private func scrollContent(with containerGeometry: GeometryProxy) -> some View {
        LazyVStack(spacing: cellsSpacing) {
          ForEach(items) { item in
            GeometryReader { geometry in
                let initialOffset = containerGeometry.safeAreaInsets.top + cellsInsets.top
                let offset = geometry.frame(in: .global).minY
                let scrollPageOffset = (offset - initialOffset).truncatingRemainder(dividingBy: scrollPageHeight)
                let percentOffset = scrollPageHeight == 0 ? 0 : scrollPageOffset / scrollPageHeight
                cell(item, percentOffset)
                    .environment(\.scrollScreenOffset, percentOffset)
            }
            .padding(cellsInsets)
            .containerRelativeFrame(.vertical, { length, _ in
                length - (cellsInsets.top + cellsInsets.bottom)
            })
          }
        }
        .scrollTargetLayout()
        .padding(.bottom, cellsSpacing)
    }
}

public struct ScrollScreenOffsetKey: EnvironmentKey {
    public static var defaultValue: Double = 0
}
public extension EnvironmentValues {
    var scrollScreenOffset: Double {
       get { self[ScrollScreenOffsetKey.self] }
       set { self[ScrollScreenOffsetKey.self] = newValue }
   }
}

private struct ScrollOffsetKey: PreferenceKey {
  static var defaultValue: CGFloat = 0
  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    value = nextValue()
  }
}

private struct ViewHeightKey: PreferenceKey {
  static var defaultValue: Double = .zero
  static func reduce(value: inout Double, nextValue: () -> Double) {
    value = nextValue()
  }
}

// MARK: - Preview

#Preview {
    if #available(iOS 17.0, *) {
        let items = [Item(content: "1"), Item(content: "2"), Item(content: "3"), Item(content: "4"), Item(content: "5")]
        PaginatedScrollView(items: items, scrollOffset: .constant(0), screenScrollPercent: .constant(0)) { item, visibilityPercent in
            CardView(content: "")
        }
    } else {}
}

private struct Item: Identifiable {
    let id = UUID()
    let content: String
}

private struct CardView: View {
    let content: String
    @Environment(\.scrollScreenOffset) var offset: Double
        
    var body: some View {
        ZStack {
            background
            Rectangle()
                .fill(.yellow)
        }
        .padding()
    }
    
    private var background: some View {
        Group {
            ZStack {
                Rectangle()
                    .fill(Color.blue.opacity(0.5))
                Rectangle()
                    .stroke(.black, lineWidth: 2.0)
            }
            .offset(x: -10 + offset * 800,
                    y: +10 - offset * 800)
            
            Rectangle()
                .fill(Color.blue)
            Rectangle()
                .stroke(.black, lineWidth: 4.0)
        }
    }
}
