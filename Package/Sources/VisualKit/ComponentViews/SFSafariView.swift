//
//  SwiftUIView.swift
//  VisualKit
//
//  Created by Michel-André Chirita on 25/09/2024.
//

import SwiftUI
import SafariServices

struct SFSafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: UIViewControllerRepresentableContext<Self>) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SFSafariView>) {
        // No need to do anything here
    }
}

#Preview {
    SFSafariView(url: URL(string: "http://www.google.fr")!)
}
