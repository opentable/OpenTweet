//
//  ProfilePicture.swift
//  OpenTweet
//
//  Created by Landon Rohatensky on 2023-11-02.
//

import SwiftUI

struct ProfilePicture: View {
    var user: User
    var size: CGSize = DisplayConstants.Sizes.imageSizeMedium
    @State private var image: UIImage?

    var body: some View {
        HStack {
            switch image {
            case .none:
                DisplayConstants.Images.person
                    .resizable()
                    .padding(DisplayConstants.Sizes.padding)
                    .foregroundColor(DisplayConstants.Colors.accentColor)
            case .some(let image):
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
            }
        }
        .frame(width: size.width, height: size.height)
        .background(DisplayConstants.Colors.backgroundColor)
        .cornerRadius(size.width / 2)
        .padding(0)
        .accessibilityLabel(user.author)
        .task {
            if let avatar = user.avatar, let url = URL(string: avatar) {
                let image = try? await ImageService.getImage(url: url)
                await MainActor.run {
                    self.image = image
                }
            }
        }
    }
}

#Preview {
    ProfilePicture(user: PreviewConstants.shortTweet.toUser())
}
