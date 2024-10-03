//
//  OurOtherAppsViewDemo.swift
//  VisualKit-Sample
//
//  Created by Michel-André Chirita on 03/10/2024.
//

import SwiftUI
import VisualKit

struct OurOtherAppsViewDemo: View {
    
    let apps: [OurOtherAppsView.App] = [OurOtherAppsView.App(name: "My other app", appStoreId: "xyz", icon: UIImage(named: "ListDecoBgdTile")!)]
    
    var body: some View {
        OurOtherAppsView(apps: apps)
            .navigationTitle("OurOtherAppsView")
    }
}

#Preview {
    OurOtherAppsViewDemo()
}
