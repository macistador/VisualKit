//
//  ContentView.swift
//  VisualKit-Sample
//
//  Created by Michel-André Chirita on 22/09/2024.
//

import SwiftUI

struct ContentView: View {
    
    @State var buttonsSection = true
    @State var containersSection = true
    @State var textSection = true
    @State var decorationsSection = true
    @State var viewsSection = true
    @State var othersSection = true
    @State var viewModifiersSection = true

    var body: some View {
        NavigationStack {
            List {
                Section("Buttons", isExpanded: $buttonsSection) {
//                    DisclosureGroup("sub cat") {}

                    NavigationLink {
                        GenericButtonDemo()
                    } label: {
                        Text("GenericButton")
                    }
                    
                    NavigationLink {
                        GlyphButtonDemo()
                    } label: {
                        Text("GlyphButton")
                    }
                    
                    NavigationLink {
                        TextButtonDemo()
                    } label: {
                        Text("TextButton")
                    }
                }
                
                Section("Containers", isExpanded: $containersSection) {
                    NavigationLink {
                        DoubleGridDemo()
                    } label: {
                        Text("DoubleGrid")
                    }
                    
                    NavigationLink {
                        ChipsStackDemo()
                    } label: {
                        Text("ChipsStack")
                    }
                }
                
                Section("Text / titles", isExpanded: $textSection) {
                    NavigationLink {
                        TitleViewDemo()
                    } label: {
                        Text("TitleView")
                    }
                    
                    NavigationLink {
                        AnimatedTextFieldDemo()
                    } label: {
                        Text("AnimatedTextField")
                    }
                    
                    NavigationLink {
                        TextBadgeViewDemo()
                    } label: {
                        Text("TextBadgeView")
                    }
                    
                    NavigationLink {
                        MessageBannerViewDemo()
                    } label: {
                        Text("ErrorMessageView")
                    }
                }
                
                Section("Decorations", isExpanded: $decorationsSection) {
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
                }
                
                Section("Screens", isExpanded: $viewsSection) {
                    NavigationLink {
                        ForceUpdateDemo()
                    } label: {
                        Text("ForceUpdateView")
                    }
                }
                
                Section("Others", isExpanded: $othersSection) {
                    NavigationLink {
                        SendMailViewDemo()
                    } label: {
                        Text("SendMailView")
                    }
                }
                
                Section("ViewModifiers", isExpanded: $viewModifiersSection) {
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
                    
                    NavigationLink {
                        DistorsionEffectDemo()
                    } label: {
                        Text("DistorsionEffect")
                    }
                }
            }
            .listStyle(.sidebar)
            .navigationTitle("VisualKit")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        buttonsSection.toggle()
                        containersSection.toggle()
                        textSection.toggle()
                        decorationsSection.toggle()
                        viewsSection.toggle()
                        othersSection.toggle()
                        viewModifiersSection.toggle()
                    } label: {
                        Text("Toggle all")
                    }

                }
            }
        }
    }
}

#Preview {
    ContentView()
}
