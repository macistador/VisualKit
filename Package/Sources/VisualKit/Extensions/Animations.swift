//
//  File.swift
//  VisualKit
//
//  Created by Michel-André Chirita on 06/10/2024.
//

import SwiftUI

@available(iOS 16.0, *)
extension ViewModifier {
    func animate(duration: CGFloat, _ execute: @escaping () -> Void) async {
        await withCheckedContinuation { continuation in
            withAnimation(.linear(duration: duration)) {
                execute()
            }
    
//            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                continuation.resume()
//            }
        }
        try? await Task.sleep(for: .seconds(duration))
    }
}
