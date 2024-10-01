//
//  AnimatedDecorationsViewDemo.swift
//  VisualKit-Sample
//
//  Created by Michel-André Chirita on 01/10/2024.
//

import SwiftUI
import VisualKit

struct AnimatedDecorationsViewDemo: View {
    
    @State var scene: AnimatedDecorationsView.Scene = .scene1
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(alignment: .leading, spacing: 30) {
                Button {
                    scene = .scene1
                } label: {
                    Text("Scene 1")
                        .font(.title)
                }

                Button {
                    scene = .scene2(withBlur: false)
                } label: {
                    Text("Scene 2 without blur")
                        .font(.title)
                }
                
                Button {
                    scene = .scene2(withBlur: true)
                } label: {
                    Text("Scene 2 with blur")
                        .font(.title)
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
                RadialGradient(colors: [Color.blue, Color.cyan], center: .center, startRadius: 0, endRadius: 1000)
                AnimatedDecorationsView(scene: scene)
            }
            .ignoresSafeArea()
        }
        .navigationTitle("AnimatedDecorationsView")
    }
}

#Preview {
    AnimatedDecorationsViewDemo()
}
