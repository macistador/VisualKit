//
//  TextBadgeViewDemo.swift
//  VisualKit-Sample
//
//  Created by Michel-André Chirita on 22/09/2024.
//

import SwiftUI
import VisualKit

struct TextBadgeViewDemo: View {
    
    @State var text: String = "Adjustable"
    @State var borderWidth: Double = 3
    @State var cornerRadius: Double = 20
    @State var fontSize: Double = 16
    @State var minWidth: Double = 150
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            TextBadgeView(text: "Some attribute", color: .yellow)

            TextBadgeView(text: "Another attribute",
                          color: .red, minWidth: 200)

            TextBadgeView(text: "Something", color: .pink, cornerRadius: 2, minWidth: 0)
            
            TextBadgeView(text: "Nay", color: .green, borderWidth: 5, cornerRadius: 30, fontSize: 30)
            
            TextBadgeView(text: "Taala", color: .custom(Color.gray))
            
            VStack(spacing: 20) {
                TextBadgeView(text: text, color: .blue, borderWidth: borderWidth, cornerRadius: cornerRadius, fontSize: fontSize, minWidth: minWidth)
                    .padding(.vertical)
                
                TextField(text: $text) {
                    Text("Title")
                }
                .textFieldStyle(.roundedBorder)
                
                HStack {
                    Text("Border width")
                    Spacer()
                    Slider(value: $borderWidth, in: (0...10.0), step: 1)
                        .containerRelativeFrame(.horizontal) { length, _ in length * 0.4 }
                }
                
                HStack {
                    Text("Corner radius")
                    Spacer()
                    Slider(value: $cornerRadius, in: (0...30.0), step: 1)
                        .containerRelativeFrame(.horizontal) { length, _ in length * 0.4 }
                }
                
                HStack {
                    Text("Font size")
                    Spacer()
                    Slider(value: $fontSize, in: (5...60.0), step: 1)
                        .containerRelativeFrame(.horizontal) { length, _ in length * 0.4 }
                }
                
                HStack {
                    Text("Min width")
                    Spacer()
                    Slider(value: $minWidth, in: (0...300.0), step: 1)
                        .containerRelativeFrame(.horizontal) { length, _ in length * 0.4 }
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).fill(.gray).opacity(0.2))
            .padding()
            
            Spacer()
        }
        .padding()
        .navigationTitle("TextBadgeView")
    }
}

#Preview {
    TextBadgeViewDemo()
}
