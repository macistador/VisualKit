//
//  SwiftUIView.swift
//  VisualKit
//
//  Created by Michel-André Chirita on 25/09/2024.
//

import SwiftUI

@available(iOS 17.0, *)
public struct SnakeEffectModifier: ViewModifier {
    
    var thickness: Double = 5
    @State var effectAmplitude = 2.0
    @State var effectSpeed = 3.0
    @State var effectInversedFrequency = 13.0
    @State private var startDate = Date()

    public func body(content: Content) -> some View {
        TimelineView(.animation) { context in
            content
                .distortionEffect(ShaderLibrary.bundle(Bundle.module).simpleWave2(.float(startDate.timeIntervalSinceNow), .float(effectInversedFrequency), .float(effectSpeed), .float(effectAmplitude)), maxSampleOffset: CGSize(width: thickness * 2, height: thickness * 2))
        }
        .frame(height: thickness)
    }
    
//    private lazy var metalLibrary: MTLLibrary? = {
//        let metalLibURL: URL = Bundle.module.url(forResource: "Shaders", withExtension: "metallib", subdirectory: "ViewModifiers")!
//        guard let metalDevice: MTLDevice = MTLCreateSystemDefaultDevice() else { return nil }
//        guard let metalLib: MTLLibrary = try? metalDevice.makeLibrary(filepath: metalLibURL.path) else { return nil }
////        guard let metalShader: MTLFunction = metalLib.makeFunction(name: "simpleWave2") else { return }
//        return metalLib
//    }()
}

@available(iOS 17.0, *)
public extension View {
    public func snakeEffect(thickness: Double = 5, effectAmplitude: Double = 2.0, effectSpeed: Double = 3.0, effectInversedFrequency: Double = 13) -> some View {
        self.modifier(SnakeEffectModifier(thickness: thickness, effectAmplitude: effectAmplitude, effectSpeed: effectSpeed, effectInversedFrequency: effectInversedFrequency))
    }
}

struct SnakeEffectModifierDemoView: View {
    @State private var snakeColor = Color.white.opacity(0.8)

    var body: some View {
        VStack {
            Spacer()
            if #available(iOS 17.0, *) {
                snakeView
            }
            Spacer()
        }
        .background(Color.red)
    }
    
    @available(iOS 17.0, *)
    @ViewBuilder
    private var snakeView: some View {
        TimelineView(.animation) { context in
            Capsule()
                .fill(snakeColor)
                .scaleEffect(0.8)
                .snakeEffect()
        }
        .frame(height: 5)
    }
}

#Preview {
    SnakeEffectModifierDemoView()
}
