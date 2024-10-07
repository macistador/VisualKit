//
//  OnboardingDropContainerView.swift
//  VisualKit-Sample
//
//  Created by Michel-André Chirita on 07/10/2024.
//

import SwiftUI
import VisualKit

struct OnboardingDropContainerView<Content: View>: View {

    private let content: () -> Content
    private let title: String
    private let subtitle: String
    private let action: () -> Void
    @Binding private var buttonState: GenericButton.ButtonState

    init(title: String, subtitle: String, buttonState: Binding<GenericButton.ButtonState>, action: @escaping () -> Void,  @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.subtitle = subtitle
        self.action = action
        self.content = content
        self._buttonState = buttonState
    }

    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .background {
                        content()
                            .overlay {
                                LinearGradient(colors: [.primaryBackground, .primaryBackground.opacity(0)], startPoint: UnitPoint(x: 0.5, y: 0.8), endPoint: UnitPoint(x: 0.5, y: 0.6))
                            }
                    }
                    .clipped()
                    .ignoresSafeArea()

                VStack {
                    Spacer()

                    TitleView(title: title,
                              subtitle: subtitle)

                    GenericButton("Continue", state: $buttonState, colors: .init(primaryButton: .clear, primaryButtonText: .primaryText), reliefStyle: .shadow) {
                        action()
                    }
                    .padding(.bottom)
                }

            }
        }
        .transition(.opacity)
    }
}

//#Preview {
//    OnboardingDropContainerView()
//}
