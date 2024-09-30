//
//  SwiftUIView.swift
//  VisualKit
//
//  Created by Michel-André Chirita on 29/09/2024.
//

import SwiftUI

@available(iOS 17.0, *)
public struct PaginatedScrollView<Content: View, Item: Identifiable>: View {
    
    let axes: Axis.Set
    @State var items: [Item]
    @Binding var scrollOffset: Double
    @Binding var screenScrollPercent: Double
    @Binding var scrollContentLength: Double
    let cellsInsets: EdgeInsets
    let cellsSpacing: Double
    @ViewBuilder var cell: (_ item: Item, _ visibilityPercent: Double)->Content
    @State private var scrollPageLength = 0.0
    private var isVertical: Bool { axes == .vertical }
    
    public init(axes: Axis.Set = .vertical,
                items: [Item],
                scrollOffset: Binding<Double> = .constant(0),
                screenScrollPercent: Binding<Double> = .constant(0),
                scrollContentLength: Binding<Double> = .constant(0),
                cellsInsets: EdgeInsets? = nil,
                cellsSpacing: Double? = nil,
                @ViewBuilder cell: @escaping (_ item: Item, _ visibilityPercent: Double)->Content) {
        self.axes = axes
        self.items = items
        self._scrollOffset = scrollOffset
        self._screenScrollPercent = screenScrollPercent
        self._scrollContentLength = scrollContentLength
        self.cellsInsets = cellsInsets ?? (axes == .vertical ? .init(top: 20, leading: 0, bottom: 20, trailing: 0) : .init(top: 0, leading: 20, bottom: 0, trailing: 20))
        self.cellsSpacing = cellsSpacing ?? (axes == .vertical ? 100.0 : 0.0)
        self.cell = cell
    }
    
    public var body: some View {
        GeometryReader { containerGeometry in
            if #available(iOS 17, *) {
                ScrollView(axes, showsIndicators: false) {
                    ZStack {
                        scrollReader(with: containerGeometry)
                        stack {
                            scrollContent(with: containerGeometry)
                        }
                    }
                }
                .scrollTargetBehavior(.viewAligned(limitBehavior: .always))
            } else {
                ScrollView(axes, showsIndicators: false) {
                    ZStack {
                        scrollReader(with: containerGeometry)
                        stack {
                            scrollContent(with: containerGeometry)
                        }
                    }
                }
                .scrollTargetBehavior(.viewAligned)
            }
        }
    }
    
    @ViewBuilder
    private func scrollReader(with containerGeometry: GeometryProxy) -> some View {
        GeometryReader { proxy in
            let proxyFrame = proxy.frame(in: .named("scroll"))
            let offset = isVertical ? proxyFrame.minY : proxyFrame.minX
            Color.clear
                .preference(key: ScrollOffsetKey.self, value: offset)
                .onAppear { scrollContentLength = isVertical ? proxy.size.height : proxy.size.width }
        }
        .onPreferenceChange(ScrollOffsetKey.self) { value in
            scrollOffset = value
            let safeAreaInsets = containerGeometry.safeAreaInsets
            let initialOffset = isVertical ? safeAreaInsets.top : safeAreaInsets.leading
            let scrollPageOffset = (initialOffset - value).truncatingRemainder(dividingBy: scrollPageLength + cellsSpacing)
            screenScrollPercent = scrollPageLength == 0 ? 0 : scrollPageOffset / (scrollPageLength + cellsSpacing)
//            print("Scroll percent: \(screenScrollPercent), pageOffset: \(scrollPageOffset)")
        }
        .preference(key: ViewLengthKey.self, value: isVertical ? containerGeometry.frame(in: .global).height : containerGeometry.frame(in: .global).width)
        .onPreferenceChange(ViewLengthKey.self) { value in
          scrollPageLength = value
        }
    }
    
    @ViewBuilder
    private func stack<StackContent: View>(@ViewBuilder content: ()->StackContent) -> some View {
        if isVertical {
            LazyVStack(spacing: cellsSpacing) {
                content()
            }
            .scrollTargetLayout()
//            .padding(.bottom, cellsSpacing)
        } else {
            LazyHStack(spacing: cellsSpacing) {
                content()
            }
            .scrollTargetLayout()
//            .padding(.trailing, cellsSpacing)
        }
    }
    
    @ViewBuilder
    private func scrollContent(with containerGeometry: GeometryProxy) -> some View {
        ForEach(items) { item in
            GeometryReader { geometry in
                let safeAreaInsets = containerGeometry.safeAreaInsets
                let initialOffset = isVertical ? safeAreaInsets.top + cellsInsets.bottom : safeAreaInsets.leading + cellsInsets.trailing
                let geometryFrame = geometry.frame(in: .global)
                let offset = isVertical ? geometryFrame.minY : geometryFrame.minX
                let pageLength = scrollPageLength + safeAreaInsets.top + cellsInsets.bottom
                let scrollPageOffset = (offset - initialOffset).truncatingRemainder(dividingBy: pageLength)
                let percentOffset = scrollPageLength == 0 ? 0 : scrollPageOffset / pageLength
                cell(item, percentOffset)
                    .environment(\.scrollScreenOffset, percentOffset)
            }
            .padding(cellsInsets)
            .containerRelativeFrame(isVertical ? .vertical : .horizontal)
        }
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

private struct ViewLengthKey: PreferenceKey {
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
    
    @ViewBuilder
    private var background: some View {
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
