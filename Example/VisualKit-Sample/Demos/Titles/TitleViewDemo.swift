//
//  TitleViewDemo.swift
//  VisualKit-Sample
//
//  Created by Michel-André Chirita on 25/09/2024.
//

import SwiftUI
import VisualKit

struct TitleViewDemo: View {
    var body: some View {
        VStack {
            Spacer()
            TitleView(title: "Amazing", titleSize: 60, subtitle: "This is an incredible subtitle", subtitleSize: 30, alignment:  .leading)
            Spacer()
        }
        .navigationTitle("TitleView")
    }
}

#Preview {
    TitleViewDemo()
}
