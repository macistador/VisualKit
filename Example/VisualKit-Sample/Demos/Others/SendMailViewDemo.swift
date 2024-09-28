//
//  SendMailViewDemo.swift
//  VisualKit-Sample
//
//  Created by Michel-André Chirita on 25/09/2024.
//

import SwiftUI
import VisualKit
import MessageUI

struct SendMailViewDemo: View {
    
    @State private var showMailView: Bool = false
    @State private var showNoEmailAlert: Bool = false
    @State private var messageResult: Result<MFMailComposeResult, Error>? = nil

    var body: some View {
        VStack {
            Spacer()
            Button {
                if SendMailView.canSendMail {
                    showMailView = true
                } else {
                    showNoEmailAlert = true
                }
            } label: {
                Text("Send mail")
            }
            Spacer()
        }
        .navigationTitle("SendMailView")
        .sheet(isPresented: $showMailView) {
            SendMailView(subject: "[User feedback]",
                         message: emailContent(),
                         toEmailAddress: "my@email.com",
                         isShowing: $showMailView,
                         result: $messageResult)
        }
        .alert("This device can't send emails", isPresented: $showNoEmailAlert, actions: {
            Button("OK", role: .cancel) {}
        })
    }
    
    private func emailContent() -> String {
        let iOSVersion = "\(UIDevice.current.systemVersion)"
        let appVersion = "\(appVersion) (\(appBuildNumber))"
        let messageBody = String(format: "Feature request or bug report?\n\n\n\nPlease don't remove this data, we use it to provide the best assistance possible.\nApp : %@ \nVersion : %@ \nUser ID :  \nDevice : %@",
                                 iOSVersion,
                                 appVersion,
                                 UIDevice.current.name)
        return messageBody
    }
    
    private var appVersion: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
    }

    private var appBuildNumber: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "1.0"
    }
}

#Preview {
    SendMailViewDemo()
}
