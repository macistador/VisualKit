//
//  FeedbackViewDemo.swift
//  VisualKit-Sample
//
//  Created by Michel-André Chirita on 03/10/2024.
//

import SwiftUI
import VisualKit

struct FeedbackViewDemo: View {

    @Environment(\.dismiss) var dismiss

    var body: some View {
        FeedbackView(infoText: infoText) { feedback in
            if let feedback {
                print("View closed with feedback: \(feedback)")
                // Handle the feedback...
            } else {
                print("View closed without feedback")
            }
            dismiss()
        }
        .navigationTitle("FeedbackView")
    }
    
    private var infoText = "Explainations & privacy information..."
}

#Preview {
    FeedbackViewDemo()
}
