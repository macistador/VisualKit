//
//  SwiftUIView.swift
//  VisualKit
//
//  Created by Michel-André Chirita on 30/09/2024.
//

import SwiftUI

public struct ParallaxBackground: View {
    
    public enum Background {
        case tile(tileImage: UIImage)
        case tileAndColor(tileImage: UIImage, color: Color?)
        case tileAndImage(tileImage: UIImage, bgdImage: UIImage)
    }
    
    let axes: Axis.Set
    let length: Double
    var background: Background
    @Binding var offset: Double
    let offsetMultiplier: Double
    private var isVertical: Bool { axes == .vertical }

    public init(axes: Axis.Set,
                length: Double = 50,
                background: Background,
                offset: Binding<Double>,
                offsetMultiplier: Double = 0.1) {
        self.axes = axes
        self.length = length
        self.background = background
        self._offset = offset
        self.offsetMultiplier = offsetMultiplier
    }
    
    public var body: some View {
        switch background {
        case .tile(tileImage: let tileImage):
            Color.clear
                .ignoresSafeArea()
                .overlay {
                    overlayTile(tileImage: tileImage)
                }
        case .tileAndColor(let tileImage, let color):
            color
                .ignoresSafeArea()
                .overlay {
                    overlayTile(tileImage: tileImage)
                }
        case .tileAndImage(let tileImage, let bgdImage):
            Image(uiImage: bgdImage)
                .resizable()
                .ignoresSafeArea()
                .overlay {
                    overlayTile(tileImage: tileImage)
                }
        }
    }
    
    private func overlayTile(tileImage: UIImage) -> some View {
        Image(uiImage: tileImage)
            .resizable(resizingMode: .tile)
            .opacity(0.1)
            .frame(width: isVertical ? 1000 : length,
                   height: isVertical ? length : 3000)
            .offset(x: isVertical ? 0 : -100 + offset * offsetMultiplier,
                    y: isVertical ? -100 + offset * offsetMultiplier : 0)
    }
}

//#Preview {
//    ParallaxBackground(background: .tile(tileImage: .listDecoBgdTile), offset: .constant(0))
//}
