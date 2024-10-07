//
//  OnboardingDropPhotoWallView.swift
//  VisualKit-Sample
//
//  Created by Michel-André Chirita on 07/10/2024.
//

import SwiftUI

struct OnboardingDropPhotoWallView: View {
    
    private var photosStack: [ImageResource] = [.sample6, .sample8, .sample7, .sample9, .sample]
    private var range2 = (0..<30)
    private var range1 = (0..<30).shuffled()
    private var range3 = (0..<30).shuffled()
    private let duration: TimeInterval = 30
    @State private var translated = false
    @State private var rotated = true

    var body: some View {
        HStack {
            LazyVStack {
                ForEach(range1, id: \.self) { photoCell(photosStack[$0 % 5]) }
            }
            .frame(width: 200)
            .offset(y: translated ? -50 : -2500)

            LazyVStack {
                ForEach(range2, id: \.self) { id in
                    photoCell(photosStack[id % 5])
                }
            }
            .frame(width: 200)
            .offset(y: translated ? 50 : 2500)

            LazyVStack {
                ForEach(range3, id: \.self) { photoCell(photosStack[$0 % 5]) }
            }
            .frame(width: 200)
            .offset(y: translated ? -50 : -2500)
        }
        .rotationEffect(.degrees(rotated ? 20 : 0))
        .task {
            withAnimation(.linear(duration: 40).repeatForever(autoreverses: true)) {
                translated = true
            }
        }
    }

    private func photoCell(_ image: ImageResource) -> some View {
        RoundedRectangle(cornerRadius: 20)
        //            .frame(height: 150)
        //            .aspectRatio(0.7, contentMode: .fit)
            .frame(width: 200, height: 250)
            .foregroundColor(.clear)
            .background {
                Image(image)
                    .resizable()
                    .scaledToFill()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    OnboardingDropPhotoWallView()
}
