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
    @State var onboardingSection = true
    @State var viewsSection = true
    @State var othersSection = true
    @State var viewModifiersSection = true

    var body: some View {
        NavigationStack {
            List {
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
                
                Section("Buttons", isExpanded: $buttonsSection) {
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
                    .disabled(true)
                }
                
                Section("Decorations", isExpanded: $decorationsSection) {
                    NavigationLink {
                        BrushViewDemo()
                    } label: {
                        Text("BrushView")
                    }
                    
                    NavigationLink {
                        AnimatedDecorationsViewDemo()
                    } label: {
                        Text("AnimatedDecorationsView")
                    }
                    
                    NavigationLink {
                        DragIndicatorViewDemo()
                    } label: {
                        Text("DragIndicatorView")
                    }
                }
                
                Section("Containers", isExpanded: $containersSection) {
                    NavigationLink {
                        DoubleGridDemo(layout: .bottom)
                    } label: {
                        Text("DoubleGrid (bottom)")
                    }
                    
                    NavigationLink {
                        DoubleGridDemo(layout: .top(reversed: true))
                    } label: {
                        Text("DoubleGrid (top)")
                    }
                    
                    NavigationLink {
                        PaginatedScrollViewDemo(axes: .vertical)
                    } label: {
                        Text("PaginatedScrollView (vertical)")
                    }
                    
                    NavigationLink {
                        PaginatedScrollViewDemo(axes: .horizontal)
                    } label: {
                        Text("PaginatedScrollView (horizontal)")
                    }
                    
                    NavigationLink {
                        ChipsStackDemo()
                    } label: {
                        Text("ChipsStack")
                    }
                }
                
                Section("Onboarding", isExpanded: $onboardingSection) {
                    NavigationLink {
                        OnboardingSlideshowViewDemo(style: .first)
                    } label: {
                        Text("OnboardingSlideshow (Style 1)")
                    }
                    
                    NavigationLink {
                        OnboardingSlideshowViewDemo(style: .second)
                    } label: {
                        Text("OnboardingSlideshow (Style 2)")
                    }
                    
                    NavigationLink {
                        OnboardingDropSlideshowViewDemo()
                    } label: {
                        Text("OnboardingDropSlideshow")
                    }
                }
                
                Section("Screens", isExpanded: $viewsSection) {
                    NavigationLink {
                        FeedbackViewDemo()
                    } label: {
                        Text("FeedbackView")
                    }
                    
                    NavigationLink {
                        ForceUpdateDemo()
                    } label: {
                        Text("ForceUpdateView")
                    }
                    
                    NavigationLink {
                        OurOtherAppsViewDemo()
                    } label: {
                        Text("OurOtherAppsView")
                    }
                    
                    NavigationLink {
                        EmptyView()
                    } label: {
                        Text("SettingsView")
                    }
                    .disabled(true)
                    
                    NavigationLink {
                        EmptyView()
                    } label: {
                        Text("ChatView")
                    }
                    .disabled(true)

                    NavigationLink {
                        EmptyView()
                    } label: {
                        Text("AppReviewPrompt")
                    }
                    .disabled(true)

                    NavigationLink {
                        EmptyView()
                    } label: {
                        Text("ProfileView")
                    }
                    .disabled(true)
                }
                
                Section("ViewModifiers", isExpanded: $viewModifiersSection) {
                    NavigationLink {
                        ShineEffectDemo()
                    } label: {
                        Text("ShineEffect")
                    }
                    
                    NavigationLink {
                        ViewPopEffectDemo()
                    } label: {
                        Text("ViewPopEffect")
                    }
                    
                    NavigationLink {
                        FancyEffectDemo()
                    } label: {
                        Text("FancyEffectDemo")
                    }
                    
                    NavigationLink {
                        InnerHaloEffectDemo()
                    } label: {
                        Text("InnerHaloEffect")
                    }
                    
                    NavigationLink {
                        FullScreenTitleEffectDemo()
                    } label: {
                        Text("FullScreenTitleEffect")
                    }
                    
                    NavigationLink {
                        ReflectionEffectDemo()
                    } label: {
                        Text("ReflectionEffect")
                    }

                    NavigationLink {
                        RaysEffectDemo()
                    } label: {
                        Text("RaysEffect")
                    }
                    
                    NavigationLink {
                        DistorsionEffectDemo()
                    } label: {
                        Text("DistorsionEffect")
                    }
                    
                    NavigationLink {
                        AnimatedShapeViewDemo()
                    } label: {
                        Text("AnimatedShapeView")
                    }
                    
                    NavigationLink {
                        PlaceholderEffectDemo()
                    } label: {
                        Text("PlaceholderEffect")
                    }
                    .disabled(true)
                }
                
                Section("Others", isExpanded: $othersSection) {
                    NavigationLink {
                        SendMailViewDemo()
                    } label: {
                        Text("SendMailView")
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
                        onboardingSection.toggle()
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
