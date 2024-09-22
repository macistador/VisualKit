//
//  ContentView.swift
//  VisualKit-Sample
//
//  Created by Michel-André Chirita on 22/09/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Components")) {
                    NavigationLink {
                        BrushViewDemo()
                    } label: {
                        Text("BrushView")
                    }

                    NavigationLink {
                        DragIndicatorViewDemo()
                    } label: {
                        Text("DragIndicatorView")
                    }
                    
                    NavigationLink {
                        MessageBannerViewDemo()
                    } label: {
                        Text("ErrorMessageView")
                    }
                    
                    NavigationLink {
                        GenericButtonDemo()
                    } label: {
                        Text("GenericButton")
                    }
                    
                    NavigationLink {
                        TextBadgeViewDemo()
                    } label: {
                        Text("TextBadgeView")
                    }
                }
                
                Section(header: Text("View Modifiers")) {
                    NavigationLink {
                        PlaceholderEffectDemo()
                    } label: {
                        Text("PlaceholderEffect")
                    }
                    
                    NavigationLink {
                        RaysEffectDemo()
                    } label: {
                        Text("RaysEffect")
                    }
                    
                    NavigationLink {
                        ShineEffectDemo()
                    } label: {
                        Text("ShineEffect")
                    }
                }
            }
            .navigationTitle("VisualKit")
            .navigationBarTitleDisplayMode(.large)
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
