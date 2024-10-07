//
//  OnboardingDropSlideshowViewDemo.swift
//  VisualKit-Sample
//
//  Created by Michel-André Chirita on 07/10/2024.
//

import SwiftUI
import VisualKit

struct OnboardingDropSlideshowViewDemo: View {

    @State private var buttonState: GenericButton.ButtonState = .enabled
    @State private var step: Int = 0
    @State private var contentVisible: Bool = true
//    private var analyticsService: AnalyticsService
    @State private var firstTimeAnalytics = true

    var body: some View {
        Group {
            if contentVisible {
                if step == 0 {
                    OnboardingDropContainerView(title: "Make your camera roll social",
                                       subtitle: "Instantly share photos with your besties",
                                       buttonState: $buttonState,
                                       action: { nextStep() }) {
                        OnboardingDropPhotoWallView()
                    }
                                       .transition(.opacity)
//                                       .onLongPressGesture(minimumDuration: 5.0) {
//                                           viewModel.displayDebug.toggle()
//                                       }
                    
//                    if viewModel.displayDebug {
//                        NavigationLink(destination: LogsView()) {
//                            Label("Logs", systemImage: "eye.trianglebadge.exclamationmark.fill")
//                        }
//                    }
                    
                } else if step == 1 {
                    OnboardingDropContainerView(title: "Snap, Post, Relive!",
                                       subtitle: "Capture Every Moment, Share Every Memory.",
                                       buttonState: $buttonState,
                                       action: { nextStep() }) {
                        OnboardingDropHDPhotoView()
                    }
                                       .transition(.opacity)
                } else if step == 2 {
                    OnboardingDropContainerView(title: "Chat",
                                       subtitle: "Turn your memories into stories",
                                       buttonState: $buttonState,
                                       action: { goNext() }) {
                        OnboardingDropChatView()
                    }
                                       .transition(.opacity)
                } else {
                    Rectangle()
                }
            }
        }
        .onAppear {
            if firstTimeAnalytics {
                firstTimeAnalytics = false
//                analyticsService.send(event: LoginAnalytics.screen)
            }
        }
    }
    
    private func nextStep() {
        withAnimation(.easeIn(duration: 0.5)) {
            contentVisible = false
        }
        withAnimation(.easeIn(duration: 0.5).delay(0.5)) {
            step += 1
            contentVisible = true
        }
    }
    
    private func goNext() {
//        viewModel.didTapNext()
    }
}

#Preview {
    OnboardingDropSlideshowViewDemo()
}
