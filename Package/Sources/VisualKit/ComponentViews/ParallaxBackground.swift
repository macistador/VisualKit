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
    
    var background: Background
    @Binding var offset: Double
    let offsetMultiplier: Double
    
    public init(background: Background, offset: Binding<Double>, offsetMultiplier: Double = 0.1) {
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
                    Image(uiImage: tileImage)
                        .resizable(resizingMode: .tile)
                        .opacity(0.1)
                        .frame(height: 5000)
                        .offset(y: -100 + offset * offsetMultiplier)
                }
        case .tileAndColor(let tileImage, let color):
            color
                .ignoresSafeArea()
                .overlay {
                    Image(uiImage: tileImage)
                        .resizable(resizingMode: .tile)
                        .opacity(0.1)
                        .frame(height: 5000)
                        .offset(y: -100 + offset * offsetMultiplier)
                }
        case .tileAndImage(let tileImage, let bgdImage):
            Image(uiImage: bgdImage)
                .resizable()
                .ignoresSafeArea()
                .overlay {
                    Image(uiImage: tileImage)
                        .resizable(resizingMode: .tile)
                        .opacity(0.1)
                        .frame(height: 5000)
                        .offset(y: -100 + offset * offsetMultiplier)
                }
        }
    }
}

//#Preview {
//    ParallaxBackground(background: .tile(tileImage: .listDecoBgdTile), offset: .constant(0))
//}
