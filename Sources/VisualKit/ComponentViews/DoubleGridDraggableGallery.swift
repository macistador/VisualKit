//
//  SwiftUIView.swift
//  VisualKit
//
//  Created by Michel-André Chirita on 25/09/2024.
//

import SwiftUI

@available(iOS 17.0, *)
struct DoubleGridDraggableGallery<Cell: View, Item: Identifiable>: View {
    
    @StateObject var viewModel: DoubleGridViewModel<Item>
    @Binding var offset: CGPoint
    let cellHighlight: DoubleGridCellHighlight
    @ViewBuilder var cell: (Item) -> Cell
    @State private var internalScrollPosition: Item.ID?
    @Namespace private var animation
    @State private var columns: [GridItem] = [
        GridItem(.adaptive(minimum: 120, maximum: 120), spacing: 3),
    ]
    @State private var columns2: [GridItem] = [
        GridItem(.adaptive(minimum: 85, maximum: 85), spacing: 10),
    ]

    var body: some View {
        ZStack(alignment: viewModel.layout.isBottom ? .top : .bottom) {
                VStack {
                    if !viewModel.layout.isBottom {
                        Spacer()
                    }
                    ZStack(alignment: viewModel.layout.isBottom ? .top : .bottom) {
                        verticalGridView
                            .opacity(viewModel.verticalScrollPosition == 1 ? 1 : 0)
                        horizontalFeedView
                            .frame(height: 170)
                            .opacity(viewModel.verticalScrollPosition == 1 ? 0 : 1)
                    }
                    if viewModel.layout.isBottom {
                        Spacer()
                    }
                }
                
                GeometryReader { reader in
                    LazyVStack {
                        Rectangle()
                            .foregroundStyle(.clear)
                            .frame(height: max(reader.size.height - 200, 0))
                            .onDisappear {
                                internalScrollPosition = nil
                                withAnimation(.linear(duration: 0.2)) {
                                    internalScrollPosition = self.viewModel.mediaScrollPosition
                                }
                            }
                    }
                    .padding(viewModel.layout.isBottom ? .top : .bottom, 200)
                }
                
                dragIndicator
        }
        .onChange(of: viewModel.mediaScrollPosition) { oldValue, newValue in
            withAnimation(.linear(duration: 0.2)) {
                internalScrollPosition = newValue
            }
        }
    }
    
    @ViewBuilder
    private var dragIndicator: some View {
        RoundedRectangle(cornerRadius: 20)
            .foregroundStyle(Color.white.opacity(0.5))
            .frame(width: 60, height: 5)
            .padding(viewModel.layout.isBottom ? .top : .bottom, 10)
    }
    
    @ViewBuilder
    private var horizontalFeedView: some View {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: columns, spacing: 10) {
                    ForEach(viewModel.datasource) { item in
                        cell(for: item)
                    }
                }
                .padding(.top, 20)
                .padding(.bottom, 20)
                .padding(.horizontal, 5)
                .scrollTargetLayout()
            }
            .scrollPosition(id: $internalScrollPosition, anchor: .center)
            .scrollIndicators(.never)
    }
    
    @ViewBuilder
    private var verticalGridView: some View {
        LazyVGrid(columns: columns2, spacing: 10) {
            ForEach(viewModel.datasourceMini) { item in
                cell(for: item)
            }
        }
        .padding(viewModel.layout.isBottom ? .top : .bottom, 25)
        .padding(viewModel.layout.isBottom ? .bottom : .top, 20)
        .padding(.horizontal, 5)
    }
    
    @ViewBuilder
    private func cell(for item: DoubleGridViewModel<Item>.FeedItem) -> some View {
        Group {
            switch item.content {
            case .cell(let itemContent):
                cell(for: itemContent)
//                    .id(item.itemId)
            case .empty:
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.gray.opacity(0.1))
                    .aspectRatio(0.7, contentMode: .fit)
                    .padding(2)
            }
        }
    }
    
    @ViewBuilder
    private func cell(for item: Item) -> some View {
        cell(item)
            .aspectRatio(0.7, contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: 4))
            .padding(2)
            .background {
                switch cellHighlight {
                case .background(let color):
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundStyle(viewModel.mediaScrollPosition == item.id ? color : .clear)
                case .stroke(let color, let cornersRadius):
                    RoundedRectangle(cornerRadius: cornersRadius)
                        .stroke(viewModel.mediaScrollPosition == item.id ? color : .clear, lineWidth: 3)
                }
            }
            .onTapGesture {
                internalScrollPosition = nil
                viewModel.mediaScrollPosition = item.id
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(.linear(duration: 0.2)) {
                        viewModel.verticalScrollPosition = 0
                        internalScrollPosition = item.id
                    }
                }
            }
    }
}

#Preview {
    if #available(iOS 17.0, *) {
        let items = [Item(), Item(), Item(), Item(), Item(), Item(), Item(), Item(), Item(), Item(), Item(), Item(), Item(), Item(), Item(), Item(), Item(), Item(), Item()]
        DoubleGridDraggableGallery(viewModel: DoubleGridViewModel(items: items, layout: .bottom), offset: .constant(CGPoint.zero), cellHighlight: .background(color: .blue)) { item in
            Cell(item: item)
        }
    } else {}
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
