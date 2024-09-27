//
//  SwiftUIView.swift
//  VisualKit
//
//  Created by Michel-André Chirita on 25/09/2024.
//

import SwiftUI
import UIKit
import MessageUI

public struct SendMailView: UIViewControllerRepresentable {

    public static var canSendMail: Bool {
        MFMailComposeViewController.canSendMail()
    }
    let subject: String
    let message: String
    let toEmailAddress: String
    @Binding var isShowing: Bool
    @Binding var result: Result<MFMailComposeResult, Error>?

    public init?(subject: String, message: String, toEmailAddress: String, isShowing: Binding<Bool>, result: Binding<Result<MFMailComposeResult, Error>?>) {
        guard MFMailComposeViewController.canSendMail() else { return nil }
        self.subject = subject
        self.message = message
        self.toEmailAddress = toEmailAddress
        self._isShowing = isShowing
        self._result = result
    }
    
    public final class Coordinator: NSObject, MFMailComposeViewControllerDelegate {

        @Binding var isShowing: Bool
        @Binding var result: Result<MFMailComposeResult, Error>?

        public init(isShowing: Binding<Bool>,
             result: Binding<Result<MFMailComposeResult, Error>?>) {
            _isShowing = isShowing
            _result = result
        }

        public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            defer {
                isShowing = false
            }
            guard error == nil else {
                self.result = .failure(error!)
                return
            }
            self.result = .success(result)
        }
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(isShowing: $isShowing, result: $result)
    }

    public func makeUIViewController(context: UIViewControllerRepresentableContext<SendMailView>) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.setSubject(subject)
        vc.setToRecipients([toEmailAddress])
        vc.setMessageBody(message, isHTML: false)
        vc.mailComposeDelegate = context.coordinator
        return vc
    }

    public func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: UIViewControllerRepresentableContext<SendMailView>) {

    }
}

//#Preview {
//    SendMailView(, result: <#Binding<Result<MFMailComposeResult, Error>?>#>)
//}
