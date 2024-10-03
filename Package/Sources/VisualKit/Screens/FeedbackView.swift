//
//  SwiftUIView.swift
//  VisualKit
//
//  Created by Michel-André Chirita on 03/10/2024.
//

import SwiftUI

@available(iOS 17.0, *)
public struct FeedbackView: View {

    public struct Feedback {
        var state: FeedbackState = .neutral
        var note: String?
    }
    
    public enum FeedbackState {
        case positive
        case neutral
        case negative
        
        var text: String {
            switch self {
            case .positive: "good"
            case .neutral: "not bad"
            case .negative: "bad"
            }
        }
        
        var primaryColor: Color {
            switch self {
            case .positive: .green
            case .neutral: .orange
                //                Color(UIColor(red: 85/255,
                //                                         green: 46/255,
                //                                         blue: 2/255,
                //                                         alpha: 1))
            case .negative: .red
            }
        }
        
        var secondaryColor: Color {
            if #available(iOS 18, *) {
                primaryColor.mix(with: .white, by: 0.4)
            } else {
                primaryColor.opacity(0.4)
            }
        }
        
        var tertiaryColor: Color {
            if #available(iOS 18, *) {
                primaryColor.mix(with: .white, by: 0.8)
            } else {
                primaryColor.opacity(0.8)
            }
        }
        
        var eyeHeight: Double {
            switch self {
            case .positive: 100
            case .neutral: 50
            case .negative: 50
            }
        }
        
        var eyeWidth: Double {
            switch self {
            case .positive: 100
            case .neutral: 100
            case .negative: 50
            }
        }
        
        var smileRadius: Double {
            switch self {
            case .positive: 30
            case .neutral: 0
            case .negative: -30
            }
        }
    }
    
    let displayCloseButton: Bool
    let title: String
    let infoText: String?
    let closeAction: (Feedback?)->Void
    @State private var feedback: Feedback = Feedback()
    @State private var displayInfo: Bool = false
    @State private var displayNotes: Bool = false
    @State private var notes: String = ""
    @FocusState private var focusNotesTextField

    public init(displayCloseButton: Bool = false,
                title: String = "How was your experience using this app ?",
                infoText: String? = nil,
                closeAction: @escaping (Feedback?)->Void) {
        self.closeAction = closeAction
        self.displayCloseButton = displayCloseButton
        self.title = title
        self.infoText = infoText
    }
    
    public var body: some View {
        VStack(alignment: .center) {
            
            if displayCloseButton || infoText != nil {
                headerView
            }
            
            Spacer()
            
            Text(title)
                .font(.system(size: 22, weight: .bold))
                .multilineTextAlignment(.center)
                .foregroundStyle(feedback.state.primaryColor)
            
            Spacer()

            smileyView

            Spacer()

            switch feedback.state {
            case .positive:
                Text(feedback.state.text)
                    .font(.system(size: 60, weight: .black))
                    .textCase(.uppercase)
                    .foregroundStyle(feedback.state.secondaryColor)
                    .transition(.push(from: .leading).combined(with: .blurReplace))
            case .neutral:
                Text(feedback.state.text)
                    .font(.system(size: 60, weight: .black))
                    .textCase(.uppercase)
                    .foregroundStyle(feedback.state.secondaryColor)
                    .transition(.push(from: .bottom).combined(with: .blurReplace))
            case .negative:
                Text(feedback.state.text)
                    .font(.system(size: 60, weight: .black))
                    .textCase(.uppercase)
                    .foregroundStyle(feedback.state.secondaryColor)
                    .transition(.push(from: .trailing).combined(with: .blurReplace))
            }
            
            Spacer()
            
            sliderView
                .padding(.bottom)
            
            Spacer()
            
            buttonsView
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(feedback.state.tertiaryColor)
        .background(Color.white)
        .sheet(isPresented: $displayInfo) {
            if let infoText {
                VStack(spacing: 40) {
                    Text(infoText)
                    Spacer()
                    Button {
                        displayInfo = false
                    } label: {
                        Text("Close")
                    }
                }
                .padding()
                .presentationDetents([.medium])
            }
        }
        .sheet(isPresented: $displayNotes) {
            VStack(spacing: 40) {
                VStack {
                    TextField("Tell us more !", text: $notes)
                        .focused($focusNotesTextField)
                        .textFieldStyle(.plain)
                        .lineLimit(5)
                        .padding()
                    Spacer()
                }
                .background(.gray.opacity(0.5), in: .rect(cornerRadius: 20))
                .onAppear {
                    focusNotesTextField = true
                }
                
                Button {
                    feedback.note = notes
                    closeAction(feedback)
                } label: {
                    ZStack {
                        Capsule()
                            .fill(feedback.state.primaryColor)
                        HStack {
                            Text("Submit")
                                .foregroundStyle(feedback.state.tertiaryColor)
                                .fontWeight(.bold)
                            Image(systemName: "arrow.right")
                                .foregroundStyle(feedback.state.tertiaryColor)
                        }
                    }
                }
                .frame(width: 150, height: 50)
            }
            .padding()
            .presentationDetents([.medium])
        }
    }
    
    @ViewBuilder
    private var headerView: some View {
        HStack {
            if displayCloseButton {
                Button {
                    closeAction(nil)
                } label: {
                    ZStack {
                        Circle()
                            .foregroundStyle(feedback.state.secondaryColor)
                        Image(systemName: "xmark")
                            .font(.system(size: 26, weight: .medium))
                            .foregroundStyle(feedback.state.primaryColor)
                            .padding(5)
                    }
                }
            }

            Spacer()
            
            if let infoText {
                Button {
                    displayInfo = true
                } label: {
                    ZStack {
                        Circle()
                            .foregroundStyle(feedback.state.secondaryColor)
                        Image(systemName: "info.circle")
                            .font(.system(size: 26, weight: .medium))
                            .padding(5)
                            .foregroundStyle(feedback.state.primaryColor)
                    }
                }
            }
        }
        .frame(height: 50)
    }
        
    @ViewBuilder
    private var smileyView: some View {
        VStack(spacing: 0) {
            Spacer()
            HStack {
                RoundedRectangle(cornerRadius: 100)
                    .foregroundStyle(feedback.state.primaryColor)
                    .frame(width: feedback.state.eyeWidth, height: feedback.state.eyeHeight)
                    .rotationEffect(.degrees(-10))
                RoundedRectangle(cornerRadius: 100)
                    .foregroundStyle(feedback.state.primaryColor)
                    .frame(width: feedback.state.eyeWidth, height: feedback.state.eyeHeight)
                    .rotationEffect(.degrees(10))
            }
            ArcShape(lineWidth: 10, radius: feedback.state.smileRadius)
                .fill(feedback.state.primaryColor)
                .frame(width: 100, height: 50)
                .padding(.top, 40)

//            Circle()
//                .trim(from: 0.1, to: 0.4)
//                .stroke(state.color, lineWidth: 10)
//                .frame(width: 50)
//                .offset(y: -20)
//                .rotationEffect(.degrees(state == .positive ? 0 : 180))
            Spacer()
        }
        .frame(height: 170)
    }
    
    @ViewBuilder
    private var sliderView: some View {
        ZStack(alignment: sliderAlignment) {
            Capsule()
                .fill(feedback.state.secondaryColor)
                .frame(width: 200, height: 7)
                .overlay(alignment: .leading) {
                    Circle()
                        .fill(feedback.state.secondaryColor)
                        .frame(width: 15, height: 15)
                        .overlay(alignment: .bottom) {
                            Text(FeedbackState.negative.text.capitalized)
                                .font(.system(size: 18, weight: .medium))
                                .fixedSize()
                                .offset(y: 35)
                                .foregroundStyle(feedback.state.secondaryColor)
                        }
                }
                .overlay(alignment: .center) {
                    Circle()
                        .fill(feedback.state.secondaryColor)
                        .frame(width: 15, height: 15)
                        .overlay(alignment: .bottom) {
                            Text(FeedbackState.neutral.text.capitalized)
                                .font(.system(size: 18, weight: .medium))
                                .fixedSize()
                                .offset(y: 35)
                                .foregroundStyle(feedback.state.secondaryColor)
                        }
                }
                .overlay(alignment: .trailing) {
                    Circle()
                        .fill(feedback.state.secondaryColor)
                        .frame(width: 15, height: 15)
                        .overlay(alignment: .bottom) {
                            Text(FeedbackState.positive.text.capitalized)
                                .font(.system(size: 18, weight: .medium))
                                .fixedSize()
                                .offset(y: 35)
                                .foregroundStyle(feedback.state.secondaryColor)
                        }
                }
            Circle()
                .fill(feedback.state.primaryColor)
                .frame(width: 35, height: 35)
                .offset(x: sliderSelectorOffset)
                .gesture(
                    DragGesture()
                        .onChanged { drag in
                            let minX: Double
                            let maxX: Double
                            switch feedback.state {
                            case .positive:
                                minX = -200
                                maxX = 0
                            case .neutral:
                                minX = -100
                                maxX = 100
                            case .negative:
                                minX = 0
                                maxX = 200
                            }
                            guard drag.translation.width > minX && drag.translation.width < maxX else { return }
                            sliderSelectorOffset = drag.translation.width
                        }
                        .onEnded { drag in
                            let lowTreshold: Double
                            let highTreshold: Double
                            switch feedback.state {
                            case .positive:
                                lowTreshold = -130
                                highTreshold = -30
                            case .neutral:
                                lowTreshold = -30
                                highTreshold = 30
                            case .negative:
                                lowTreshold = 30
                                highTreshold = 130
                            }
                            let offset = sliderSelectorOffset
                            withAnimation {
                                if offset > highTreshold {
                                    feedback.state = .positive
                                } else if offset < lowTreshold {
                                    feedback.state = .negative
                                } else {
                                    feedback.state = .neutral
                                }
                                sliderSelectorOffset = 0
                            }
                        }
                )
        }
        .onTapGesture { point in
            withAnimation {
                if point.x > 130 {
                    feedback.state = .positive
                } else if point.x < 60 {
                    feedback.state = .negative
                } else {
                    feedback.state = .neutral
                }
            }
        }
    }
    
    @State private var sliderSelectorOffset: Double = 0
    
    private var sliderAlignment: Alignment {
        switch feedback.state {
        case .positive: .trailing
        case .neutral: .center
        case .negative: .leading
        }
    }
    
    @ViewBuilder
    private var buttonsView: some View {
        HStack {
            Button {
                displayNotes = true
            } label: {
                Text("Add note")
                    .foregroundStyle(feedback.state.primaryColor)
            }
            .padding(.horizontal, 30)
            
            Button {
                closeAction(feedback)
            } label: {
                ZStack {
                    Capsule()
                        .fill(feedback.state.primaryColor)
                    HStack {
                        Text("Submit")
                            .foregroundStyle(feedback.state.tertiaryColor)
                        Image(systemName: "arrow.right")
                            .foregroundStyle(feedback.state.tertiaryColor)
                    }
                }
            }
            .frame(width: 150)
        }
        .fontWeight(.bold)
        .frame(height: 50)
        .background(Capsule().fill(feedback.state.secondaryColor))
    }
}

#Preview {
    if #available(iOS 17.0, *) {
        FeedbackView() { _ in }
    } else {
        // Fallback on earlier versions
    }
}


private struct ArcShape: Shape {
    
    var lineWidth: Double
    var radius: Double
    var animatableData: Double {
        get { radius }
        set { radius = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: .zero)
        p.addCurve(to: CGPoint(x: rect.maxX, y: 0), control1: CGPoint(x: rect.maxX * 0.33, y: radius), control2: CGPoint(x: rect.maxX * 0.66, y: radius))
        return p.strokedPath(.init(lineWidth: lineWidth, lineCap: .round))
    }
}
