//
//  ErrorMessageViewDemo.swift
//  VisualKit-Sample
//
//  Created by Michel-André Chirita on 22/09/2024.
//

import SwiftUI
import VisualKit

struct MessageBannerViewDemo: View {
    
    @State var borderWidth: Double = 1
    @State var cornerRadius: Double = 20

    var body: some View {
        VStack {
            VStack(spacing: 40) {
                MessageBannerView(message: "Something happen that you should be informed", kind: .info)
            }
            
            VStack(spacing: 20) {
                MessageBannerView(message: "Something happen that you should be warned", kind: .warning, cornerRadius: cornerRadius, borderWidth: borderWidth)
                    .padding(.vertical)

                MessageBannerView(message: "An error occured, please don't panic!", kind: .error, cornerRadius: cornerRadius, borderWidth: borderWidth)
                    .padding(.vertical)
                                
                HStack {
                    Text("Border width")
                    Spacer()
                    Slider(value: $borderWidth, in: (0...10.0), step: 1)
                        .containerRelativeFrame(.horizontal) { length, _ in length * 0.4 }
                    Text("\(Int(borderWidth))")
                        .frame(width: 25)
                }
                
                HStack {
                    Text("Corner radius")
                    Spacer()
                    Slider(value: $cornerRadius, in: (0...30.0), step: 1)
                        .containerRelativeFrame(.horizontal) { length, _ in length * 0.4 }
                    Text("\(Int(cornerRadius))")
                        .frame(width: 25)
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).fill(.gray).opacity(0.2))
            .padding()
                
            Spacer()
        }
        .padding()
        .navigationTitle("MessageBannerView")
    }
}

#Preview {
    MessageBannerViewDemo()
}
