//
//  ProfilePicture.swift
//  OpenTweet
//
//  Created by Landon Rohatensky on 2023-11-02.
//

import SwiftUI

struct ProfilePicture: View {
    var user: User
    var size: CGSize = DisplayConstants.Sizes.imageSize
    @State private var image: UIImage?

    var body: some View {
        HStack {
            HStack {
                switch image {
                case .none:
                    Rectangle()
                        .fill(DisplayConstants.Colors.backgroundColor)
                case .some(let image):
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipped()
                }
            }
            .frame(width: size.width, height: size.height)
            .background(DisplayConstants.Colors.backgroundColor)
            .cornerRadius(DisplayConstants.Sizes.imageSize.width / 2)
            .padding(0)
        }.task {
            if let avatar = user.avatar, let url = URL(string: avatar) {
                let image = try? await ImageService.getImage(url: url)
                await MainActor.run {
                    self.image = image
                }
            }
        }
    }
}
