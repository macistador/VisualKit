//
//  SwiftUIView.swift
//  VisualKit
//
//  Created by Michel-André Chirita on 28/09/2024.
//

import SwiftUI

public struct ForceUpdateView: View {
    
    let appId: String
    let foregroundColor: Color
    let backgroundColor: Color

    public init(appId: String, foregroundColor: Color = .black, backgroundColor: Color = .white) {
        self.appId = appId
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            
            TitleView(title: "New version available !",
                      subtitle: "You must update your app from the AppStore in order to enjoy our new features 🚀",
                      color: foregroundColor,
                      alignment: .center,
                      effect: false)
            
            Spacer()
            
            GenericButton(title: "Update", colors: GenericButton.Colors(primaryButton: foregroundColor, primaryButtonText: backgroundColor)) {
                openAppStore()
            }
            .padding(.bottom, 30)
            
        }
        .background(backgroundColor)
    }
    
    func openAppStore() {
        guard let url = URL(string: "itms-apps://itunes.apple.com/app/\(appId)") else {
            return
        }
        UIApplication.shared.open(url)
    }
}

#Preview {
    ForceUpdateView(appId: "xxxx")
}
