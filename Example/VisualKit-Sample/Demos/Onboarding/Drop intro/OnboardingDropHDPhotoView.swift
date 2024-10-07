//
//  OnboardingDropHDPhotoView.swift
//  VisualKit-Sample
//
//  Created by Michel-André Chirita on 07/10/2024.
//

import SwiftUI

struct OnboardingDropHDPhotoView: View {
    
    private let photosStack1: [ImageResource] = [.sample, .sample2, .sample3, .sample4, .sample5]
    private let photosStack2: [ImageResource] = [.sample8, .sample6, .sample7, .sample9, .sample]
    private let photosStack3: [ImageResource] = [.sample5, .sample4, .sample3, .sample2, .sample6]
    private let duration: TimeInterval = 30
    @State private var translated = false
    @State private var rotated = true
    @State private var zoomed = false
    
    var body: some View {
        HStack {
            LazyVStack {
                ForEach((0..<10), id: \.self) { photoCell(photosStack1[$0 % 5]) }
            }
            .frame(width: 200)
            .offset(y: translated ? -50 : -250)
            
            LazyVStack {
                ForEach((0..<10), id: \.self) { id in
                    photoCell(photosStack2[id % 5])
                }
            }
            .frame(width: 200)
            .offset(y: translated ? 100 : 350)
            
            LazyVStack {
                ForEach((0..<10), id: \.self) { photoCell(photosStack3[$0 % 5]) }
            }
            .frame(width: 200)
            .offset(y: translated ? -50 : -250)
        }
        .rotationEffect(.degrees(rotated ? 20 : 0))
        .scaleEffect(zoomed ? 3.5 : 1.0)
        .task {
            withAnimation(.linear(duration: 2)) {
                translated = true
            }
            withAnimation(.linear(duration: 0.5).delay(1.5)) {
                rotated = false
                zoomed = true
            }
        }
    }
    
    private func photoCell(_ image: ImageResource) -> some View {
        RoundedRectangle(cornerRadius: 20)
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
    OnboardingDropHDPhotoView()
}
