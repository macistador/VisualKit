//
//  SwiftUIView.swift
//  VisualKit
//
//  Created by Michel-André Chirita on 03/10/2024.
//

import SwiftUI

public struct OurOtherAppsView: View {
    
    public struct App: Identifiable {
        public var id: String { appStoreId }
        let name: String
        let appStoreId: String
        let icon: UIImage
        
        public init(name: String, appStoreId: String, icon: UIImage) {
            self.name = name
            self.appStoreId = appStoreId
            self.icon = icon
        }
    }
    
    let apps: [App]
    
    public init(apps: [App]) {
        self.apps = apps
    }

    public var body: some View {
        ScrollView {
            VStack {
                Spacer()
                
                Text("Discover also our other apps")
                    .font(.title)
                    .bold()
                
                ForEach(apps) { app in
                    view(for: app)
                }
                
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    private func view(for app: App) -> some View {
        HStack(alignment: .center) {
            RoundedRectangle(cornerRadius: 20)
                .fill(.clear)
                .frame(width: 50, height: 50)
                .background {
                    Image(uiImage: app.icon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                .clipped()
            
            Text(app.name)
                .font(.title3)
            
            Spacer()
            
            Button {
                openAppStore(for: app)
            } label: {
                Text("See")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 10)
                    .background {
                        Capsule()
                            .fill(.blue)
                    }
            }
        }
        .padding()
    }
    
    private func openAppStore(for app: App) {
        guard let url = URL(string: "itms-apps://itunes.apple.com/app/\(app.appStoreId)") else {
            return
        }
        UIApplication.shared.open(url)
    }
}

#Preview {
    OurOtherAppsView(apps: [])
}
