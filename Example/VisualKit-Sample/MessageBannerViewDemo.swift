//
//  ErrorMessageViewDemo.swift
//  VisualKit-Sample
//
//  Created by Michel-André Chirita on 22/09/2024.
//

import SwiftUI
import VisualKit

struct MessageBannerViewDemo: View {
    var body: some View {
        VStack {
            
            VStack(spacing: 40) {
                MessageBannerView(message: "Something happen that you should be informed", kind: .info)
                
                MessageBannerView(message: "Something happen that you should be warned", kind: .warning)
                
                MessageBannerView(message: "An error occured, please don't panic!", kind: .error)
            }
                
            Spacer()
        }
        .padding()
        .navigationTitle("MessageBannerView")
    }
}

#Preview {
    MessageBannerViewDemo()
}
