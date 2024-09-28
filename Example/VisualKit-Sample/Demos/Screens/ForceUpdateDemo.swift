//
//  ForceUpdateDemo.swift
//  VisualKit-Sample
//
//  Created by Michel-André Chirita on 28/09/2024.
//

import SwiftUI
import VisualKit

struct ForceUpdateDemo: View {
    var body: some View {
        ForceUpdateView(appId: "xxxx",
                        foregroundColor: .blue,
                        backgroundColor: .white)
        .navigationTitle("ForceUpdateView")
    }
}

#Preview {
    ForceUpdateDemo()
}
