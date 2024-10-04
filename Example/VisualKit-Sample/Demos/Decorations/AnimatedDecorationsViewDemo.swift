//
//  AnimatedDecorationsViewDemo.swift
//  VisualKit-Sample
//
//  Created by Michel-André Chirita on 01/10/2024.
//

import SwiftUI
import VisualKit

struct AnimatedDecorationsViewDemo: View {
    
    @State var scene: AnimatedDecorationsView.Scene = .circles
    @State private var backgroundColors: [Color] = [Color.blue, Color.cyan]
    @State private var withFrame: Bool = false
    @State private var meshColors: Bool = false
    @State private var speedMultiplier: Double = 1.0

    var body: some View {
        VStack {
            Spacer()
            
            VStack(alignment: .center, spacing: 30) {
                HStack {
                    Text("Scenes")
                        .bold()
                        .foregroundStyle(.black)
                    Spacer()
                }
                    
                Button {
                    scene = .circles
                } label: {
                    Text("Circles")
                        .font(.title2)
                }
                
                Button {
                    scene = .bubbles(withBlur: false)
                } label: {
                    Text("Bubbles")
                        .font(.title2)
                }
                
                Button {
                    scene = .bubbles(withBlur: true)
                } label: {
                    Text("Bubbles + blur")
                        .font(.title2)
                }
                
                Button {
                    scene = .lines
                } label: {
                    Text("Lines")
                        .font(.title2)
                }
                
                Divider()
                
                HStack {
                    Text("Colors")
                        .bold()
                        .foregroundStyle(.black)
                    Spacer()
                    RoundedRectangle(cornerRadius: 4)
                        .fill(LinearGradient(colors: [Color.blue, Color.cyan], startPoint: .top, endPoint: .bottom))
                        .frame(width: 40, height: 40)
                        .clipShape(.rect)
                        .onTapGesture {
                            meshColors = false
                            backgroundColors = [Color.blue, Color.cyan]
                        }
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.orange)
                        .frame(width: 40, height: 40)
                        .onTapGesture {
                            meshColors = false
                            backgroundColors = [Color.orange]
                        }
                        RoundedRectangle(cornerRadius: 4)
                            .fill(LinearGradient(colors: [.black], startPoint: .top, endPoint: .bottom))
                            .frame(width: 40, height: 40)
                            .onTapGesture {
                                meshColors = false
                                backgroundColors = [Color.black]
                            }
                    if #available(iOS 18, *) {
                        RoundedRectangle(cornerRadius: 4)
                            .frame(width: 40, height: 40)
                            .overlay(GradientView())
                            .clipShape(.rect(cornerRadius: 20))
                            .onTapGesture {
                                meshColors = true
                            }
                    }
                }
                
                Divider()
                
                VStack(alignment: .leading) {
                    Text("Speed")
                        .bold()
                        .foregroundStyle(.black)
                    HStack {
                        Slider(value: $speedMultiplier, in: 0.0...10.0, step: 0.1) {
                            Text("Speed")
                                .foregroundStyle(.black)
                        }
                        Text(String(format: "%.1f", speedMultiplier))
                            .font(.caption)
                    }
                }
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white.opacity(0.8))
            }
            .padding()
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background {
            ZStack {
                if #available(iOS 18, *), meshColors {
                    GradientView()
                } else {
                    RadialGradient(colors: backgroundColors, center: .center, startRadius: 0, endRadius: 300)
                }
            }
            .overlay {
                AnimatedDecorationsView(scene: scene,
                                        speedMultiplier: speedMultiplier)
            }
            .ignoresSafeArea()
        }
        .navigationTitle("AnimatedDecorationsView")
    }
}

#Preview {
    AnimatedDecorationsViewDemo()
}


@available(iOS 18.0, *)
private struct GradientView: View {

    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            MeshGradient(width: 3, height: 3, points: [
                [0.0, 0.0], [0.5, 0], [1.0, 0.0],
                [0.0, 0.5], [isAnimating ? 0.1 : 0.9, 0.5], [1.0, 0.5],
                [0.0, 1.0], [0.5, 1.0], [1.0, 1.0]
            ], colors: [
                isAnimating ? .teal : .red, .purple, .indigo,
                .orange, isAnimating ? .white : .brown, .blue,
                isAnimating ? .mint : .yellow, .green, .mint
            ],
                         smoothsColors: true,
                         colorSpace: .perceptual
            )
            .onAppear {
                withAnimation(.easeInOut(duration: 5).repeatForever(autoreverses: true)) {
                    isAnimating.toggle()
                }
            }
        }
    }
}
