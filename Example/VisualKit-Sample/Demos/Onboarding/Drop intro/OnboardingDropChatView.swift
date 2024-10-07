//
//  OnboardingDropChatView.swift
//  VisualKit-Sample
//
//  Created by Michel-André Chirita on 07/10/2024.
//

import SwiftUI

struct OnboardingDropChatView: View {

    @State private var step = 0

    var body: some View {
        photoView
            .overlay {
                VStack {
                    if step > 0 {
                        ChatDemoCell(side: .left, authorPhoto: .mockUserPicture3, authorName: "Ralph", authorColor: .blue, comment: "Look what I found! 😍")
                            .frame(height: 70)
                            .padding(.top, 50)
                            .transition(.move(edge: .leading).combined(with: .opacity).combined(with: .scale))
                    }

                    if step > 1 {
                        ChatDemoCell(side: .right, authorPhoto: .mockUserPicture4, authorName: "Jannie", authorColor: .red, comment: "OMG love it!")
                            .frame(height: 70)
                            .transition(.move(edge: .trailing).combined(with: .opacity).combined(with: .scale))
                    }

                    if step > 2 {
                        ChatDemoCell(side: .right, authorPhoto: .mockUserPicture4, authorName: "Jannie", authorColor: .red, comment: "Such a fun day 😊")
                            .frame(height: 70)
                            .transition(.move(edge: .trailing).combined(with: .opacity).combined(with: .scale))
                    }

                    if step > 3 {
                        ChatDemoCell(side: .left, authorPhoto: .mockUserPicture3, authorName: "Ralph", authorColor: .blue, comment: "Totally! Let's do it again soon! 🌟")
                            .frame(height: 70)
                            .transition(.move(edge: .leading).combined(with: .opacity).combined(with: .scale))
                    }
                    Spacer()
                }
                .padding(.top, 40)
                .padding(10)
            }
            .onAppear {
                withAnimation(.bouncy(duration: 0.4).delay(0.5)) {
                    step += 1
                }
                withAnimation(.bouncy(duration: 0.4).delay(1.1)) {
                    step += 1
                }
                withAnimation(.bouncy(duration: 0.4).delay(1.7)) {
                    step += 1
                }
                withAnimation(.bouncy(duration: 0.4).delay(2.3)) {
                    step += 1
                }
            }
    }

    private var photoView: some View {
        RoundedRectangle(cornerRadius: 20)
//            .frame(height: 150)
//            .aspectRatio(0.7, contentMode: .fit)
//            .frame(width: 200, height: 250)
            .foregroundColor(.clear)
            .background {
                Image(.sample6)
                    .resizable()
                    .scaledToFill()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: 20))
//            .padding()
    }
}

#Preview {
    OnboardingDropChatView()
}


private struct ChatDemoCell: View {

    enum Side {
        case left
        case right
    }
    
    var side: Side
    var authorPhoto: ImageResource
    var authorName: String
    var authorColor: Color
    var comment: String

    var body: some View {
        HStack(spacing: 0) {
            if side == .left {
                authorPhotoView
            } else {
                Spacer()
                    .frame(maxWidth: .infinity)
            }

            bulleView

            if side == .right {
                authorPhotoView
            } else {
                Spacer()
                    .frame(maxWidth: .infinity)
            }
        }
    }

    private var authorPhotoView: some View {
        VStack {
            Spacer()
            Circle()
                .foregroundStyle(.black)
                .overlay {
                    Image(authorPhoto)
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .padding(1)
                }
                .shadow(color: .black, radius: 5)
                .frame(width: 40, height: 40)
                .padding(.trailing, side == .left ? 5 : 0)
                .padding(.leading, side == .right ? 5 : 0)
        }
    }

    private var bulleView: some View {
        VStack(alignment: .leading) {
            titleView
            contentView
        }
        .frame(maxWidth: 200, alignment: .leading)
        .padding(.vertical, 5)
        .padding(.horizontal, 5)
        .background {
            ZStack(alignment: side == .left ? .bottomLeading : .bottomTrailing) {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .foregroundStyle(.cellBackground)
                    .shadow(color: .cellBackground.opacity(0.5), radius: 0, y: 1)

//                Image(side == .left ? .chatBulleCornerLeft : .chatBulleCornerRight)
//                    .offset(x: side == .left ? -5 : 5, y: 0)
//                    .foregroundStyle(.cellBackground)
            }
        }
    }

    private var titleView: some View {
        Text(authorName)
            .font(.system(size: 14, weight: .semibold))
            .lineLimit(1)
            .foregroundStyle(Color(authorColor))
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: 200, alignment: .leading)
    }

    private var contentView: some View {
        ZStack(alignment: .topLeading) {
            Text(verbatim: comment)
                .font(.system(size: 16, weight: .regular))
                .foregroundStyle(Color.primaryText)
                .multilineTextAlignment(.leading)
                .lineLimit(50)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
