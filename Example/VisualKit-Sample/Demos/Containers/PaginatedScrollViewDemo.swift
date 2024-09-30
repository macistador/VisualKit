//
//  PaginatedScrollViewDemo.swift
//  VisualKit-Sample
//
//  Created by Michel-André Chirita on 29/09/2024.
//

import SwiftUI
import VisualKit

struct PaginatedScrollViewDemo: View {

    private struct Item: Identifiable {
        let id = UUID()
        let content: String
    }
    
    private let items = [Item(content: "1"), Item(content: "2"), Item(content: "3"), Item(content: "4"), Item(content: "5")]
    @State private var scrollOffset: Double = 0
    @State private var screenScrollPercent: Double = 0
    @State private var hapticFeedbackValue = 0.0

    var body: some View {
        ZStack {
            ParallaxBackground(background: .tileAndColor(tileImage: tileImage,
                                                         color: .green),
                               offset: $scrollOffset,
                               offsetMultiplier: 0.1)
            
            PaginatedScrollView(items: items,
                           scrollOffset: $scrollOffset,
                           screenScrollPercent: $screenScrollPercent) { item, visibilityPercent in
                CardView(content: item.content)
                    .rotation3DEffect(
                        .degrees(visibilityPercent * 47),
                        axis: (x: 0, y: 1, z: 0)
                    )
                    .scrollTransition(.animated.threshold(.visible(0.9))) { content, phase in
                        content
                            .scaleEffect(phase.isIdentity ? 1 : 0.85)
                            .blur(radius: phase.isIdentity ? 0 : 5)
                            .hueRotation(.degrees(45 * phase.value))
                    }
            }
            
            RoundedRectangle(cornerRadius: 80)
                .stroke(.white.opacity(0.8), lineWidth: 50 * sin(.pi * screenScrollPercent))
                .ignoresSafeArea()
                .blur(radius: 20)
                .allowsHitTesting(false)
        }
        .navigationTitle("PaginatedScrollView")
        .onChange(of: scrollOffset) { oldValue, newValue in
            guard abs(newValue * 0.05 - hapticFeedbackValue) > 1 else { return }
            hapticFeedbackValue = newValue * 0.05
        }
        .sensoryFeedback(trigger: hapticFeedbackValue) { oldValue, newValue in
          let amount = abs(oldValue - newValue)
          return .impact(flexibility: .soft, intensity: amount)
        }
    }
    
    private var tileImage: UIImage {
        return .listDecoBgdTile
            .resizeImage(targetSize: CGSize(width: 195, height: 375))!
    }
}

#Preview {
    PaginatedScrollViewDemo()
}

private struct CardView: View {
    let content: String
    @Environment(\.scrollScreenOffset) var offset: Double
        
    var body: some View {
        ZStack {
            background
            Rectangle()
                .fill(.yellow)
        }
        .padding()
//        .onAppear {
//            print("CELL FINAL OFFSET: \(offset)")
//        }
//        .onChange(of: offset) { oldValue, newValue in
//            print("CELL FINAL OFFSET: \(offset)")
//        }
    }
    
    private var background: some View {
        Group {
            ZStack {
                Rectangle()
                    .fill(Color.blue.opacity(0.5))
                    .stroke(.black, lineWidth: 2.0)
            }
            .offset(x: -10 + offset * 800,
                    y: +10 - offset * 800)
            
            Rectangle()
                .fill(Color.blue)
                .stroke(.black, lineWidth: 4.0)
        }
    }
}

#Preview {
    CardView(content: "")
}


private extension UIImage {
    func resizeImage(targetSize: CGSize) -> UIImage? {
      let size = self.size

      let widthRatio  = targetSize.width  / size.width
      let heightRatio = targetSize.height / size.height

      var newSize: CGSize
      if(widthRatio > heightRatio) {
        newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
      } else {
        newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
      }

      let rect = CGRect(origin: .zero, size: newSize)

      UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
      let newImage = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()

      return newImage
    }
}
