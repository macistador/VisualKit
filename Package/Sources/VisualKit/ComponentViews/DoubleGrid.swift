//
//  SwiftUIView.swift
//  VisualKit
//
//  Created by Michel-André Chirita on 25/09/2024.
//

import SwiftUI

public enum DoubleGridLayout {
    case top(reversed: Bool)
    case bottom
    
    var isBottom: Bool {
        switch self {
        case .top: false
        case .bottom: true
        }
    }
}

public enum DoubleGridCellHighlight {
    case background(color: Color)
    case stroke(color: Color, cornerRadius: Double)
}

final class DoubleGridViewModel<Item: Identifiable>: ObservableObject {

    struct FeedItem: Identifiable {
        let id: Int
        let itemId: Item.ID?
        let content: Content
        enum Content {
            case cell(Item)
            case empty
        }
    }

    @Published var datasource: [Item]
    @Published var datasourceMini: [FeedItem]
    @Published var verticalScrollPosition: Int?
    @Published var mediaScrollPosition: Item.ID?
    @Published var gridIsExpanded = false
    let layout: DoubleGridLayout

    init(items: [Item], layout: DoubleGridLayout) {
        self.layout = layout
        self.datasource = items
        switch layout {
        case .top(let reversed):
            self.datasourceMini = Array((reversed ? items : items.reversed()).enumerated())
                .map { index, item in
                    FeedItem(id: index + 4, itemId: item.id, content: .cell(item))
                }
            for index in 0..<(4 - items.count % 4) {
                self.datasourceMini.insert(FeedItem(id: index, itemId: nil, content: .empty), at: 0)
            }
            
        case .bottom:
            self.datasourceMini = Array(items.enumerated())
                .map { index, item in
                    FeedItem(id: index, itemId: item.id, content: .cell(item))
                }
        }
        mediaScrollPosition = datasource.first?.id
    }
}

@available(iOS 17.0, *)
public struct DoubleGrid<Cell: View, MiniCell: View, Item: Identifiable>: View {
    
    @ObservedObject private var viewModel: DoubleGridViewModel<Item>
    private let mainGridBackgroundColor: Color
    private let draggableGridBackgroundColor: Color
    private let cellHighlight: DoubleGridCellHighlight
    @ViewBuilder private var mainCell: (Item) -> Cell
    @ViewBuilder private var miniCell: (Item) -> MiniCell
    @State private var verticalScrollOffset: CGPoint = .zero

    public init(items: [Item],
                layout: DoubleGridLayout = .bottom,
                cellHighlight: DoubleGridCellHighlight = .background(color: .blue),
                mainGridBackgroundColor: Color = Color(white: 0.1),
                draggableGridBackgroundColor: Color = .black,
                @ViewBuilder mainCell: @escaping (Item) -> Cell,
                @ViewBuilder miniCell: @escaping (Item) -> MiniCell) {
        self.viewModel = DoubleGridViewModel(items: items, layout: layout)
        self.mainGridBackgroundColor = mainGridBackgroundColor
        self.draggableGridBackgroundColor = draggableGridBackgroundColor
        self.cellHighlight = cellHighlight
        self.mainCell = mainCell
        self.miniCell = miniCell
    }
    
    public var body: some View {
        contentView
            .background {
                mainGridBackgroundColor
            }
    }
    
    private var contentView: some View {
        GeometryReader { reader in
            ScrollViewReader { proxy in
                OffsetScrollView(axes: .vertical, showsIndicators: false, offset: $verticalScrollOffset) {
                    VStack(spacing: 0) {
                        switch viewModel.layout {
                        case .top:
                            draggableGallery(minHeight: reader.size.height * 0.82)
                                .id(1)
                                .zIndex(1)
                            horizontalFeedView(height: reader.size.height * ((reader.size.height > 600) ? (viewModel.layout.isBottom ? 0.82 : 0.80) : 0.99))
                                .id(0)
                                .zIndex(0)
                        case .bottom:
                            horizontalFeedView(height: reader.size.height * ((reader.size.height > 600) ? 0.82 : 0.99))
                                .id(0)
                                .zIndex(0)
                            draggableGallery(minHeight: reader.size.height * 0.82)
                                .id(1)
                                .zIndex(1)
                        }
                    }
                    .background(
                        GeometryReader { innerReader in
                            Color.clear
                                .onChange(of: verticalScrollOffset) { oldValue, newValue in
                                    switchGridIfNeeded(scrollHeight: reader.size.height,
                                                       contentHeight: innerReader.size.height,
                                                       offset: newValue.y)
                                    resetToFirstCellIfNeeded(scrollHeight: reader.size.height,
                                                             contentHeight: innerReader.size.height,
                                                             offset: newValue.y)
                                }
                        }
                    )
//                    .scrollTargetLayout(isEnabled: viewModel.layout.isBottom ? verticalScrollOffset.y < 750 : verticalScrollOffset.y > 450)
                    .scrollTargetLayout()
              }
                .scrollTargetBehavior(.viewAligned)
                .defaultScrollAnchor(viewModel.layout.isBottom ? .top : .bottom)
                .onChange(of: viewModel.verticalScrollPosition) { oldValue, newValue in
                    if newValue == 0, oldValue != 0 {
                        proxy.scrollTo(newValue, anchor: .bottom)
                    }
                }
            }
        }
    }
    
    private func switchGridIfNeeded(scrollHeight: Double, contentHeight: Double, offset: Double) {
        let condition = switch viewModel.layout {
        case .bottom: offset > 50
        case .top: offset <  contentHeight - scrollHeight - 50
        }
        
        viewModel.verticalScrollPosition = condition ? 1 : 0
//        print("Height: \(scrollHeight), Content: \(contentHeight), OFFSET: \(Int(offset)), scrollPosition: \(viewModel.verticalScrollPosition)")
    }
    
    private func resetToFirstCellIfNeeded(scrollHeight: Double, contentHeight: Double, offset: Double) {
        let condition = switch viewModel.layout {
        case .bottom: offset < -20
        case .top: offset > contentHeight - scrollHeight + 20
        }
        
        if condition, let firstItem = viewModel.datasource.first, viewModel.mediaScrollPosition != firstItem.id {
            viewModel.mediaScrollPosition = firstItem.id
        }
    }
    
    @ViewBuilder
    private func draggableGallery(minHeight: Double) -> some View {
        DoubleGridDraggableGallery(viewModel: viewModel,
                                   offset: $verticalScrollOffset,
                                   cellHighlight: cellHighlight,
                                   cell: miniCell)
        .background(draggableGridBackgroundColor)
        .frame(minHeight: minHeight)
    }

    @ViewBuilder
    private func horizontalFeedView(height: Double) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 0) {
                ForEach(viewModel.datasource, id: \.self.id) { item in
                    mainCell(item)
                        .aspectRatio(0.7, contentMode: .fit)
                        .padding(.horizontal)
                        .containerRelativeFrame(.horizontal)
                        .scrollTransition { content, phase in
                            content
                                .opacity(phase.isIdentity ? 1 : 0)
                                .scaleEffect(phase.isIdentity ? 1 : 0.75)
                                .blur(radius: phase.isIdentity ? 0 : 10)
                        }
                }
            }
            .scrollTargetLayout()
        }
        .scrollPosition(id: $viewModel.mediaScrollPosition)
        .scrollTargetBehavior(.paging)
        .frame(height: height)
        .scrollTransition { content, phase in
            content
                .offset(y: -phase.value * 300)
                .blur(radius: phase.isIdentity ? 0 : 10)
                .scaleEffect(phase.isIdentity ? 1 : 0.9, anchor: .bottom)
        }
    }
}

#Preview {
    if #available(iOS 17.0, *) {
        let items = [Item(), Item(), Item(), Item(), Item(), Item(), Item(), Item(), Item(), Item(), Item(), Item(), Item(), Item(), Item(), Item(), Item(), Item(), Item()]
        return DoubleGrid(items: items) { item in
            Cell(item: item)
        } miniCell: { item in
            Cell(item: item)
        }
    } else {
        return EmptyView()
    }
}

private struct Item: Identifiable {
    public let id: String = UUID().uuidString
    public let color: Color = [Color.gray, Color.green, Color.red, Color.yellow, Color.pink, Color.purple, Color.blue, Color.cyan, Color.brown, Color.indigo, Color.mint, Color.teal, Color.orange].randomElement()!
}

private struct Cell: View {
    let item: Item
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(item.color)
            .aspectRatio(0.7, contentMode: .fit)
    }
}
