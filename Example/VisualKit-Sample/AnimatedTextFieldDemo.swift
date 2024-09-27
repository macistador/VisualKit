//
//  AnimatedTextFieldDemo.swift
//  VisualKit-Sample
//
//  Created by Michel-André Chirita on 25/09/2024.
//

import SwiftUI
import VisualKit

struct AnimatedTextFieldDemo: View {
    
    @State var text = ""
    
    var body: some View {
        VStack {
            Spacer()
            AnimatedTextField(text: $text)
        }
        .padding()
    }
}

#Preview {
    AnimatedTextFieldDemo()
}
