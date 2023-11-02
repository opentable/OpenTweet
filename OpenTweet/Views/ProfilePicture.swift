//
//  ProfilePicture.swift
//  OpenTweet
//
//  Created by Landon Rohatensky on 2023-11-02.
//

import SwiftUI

struct TweetProfilePicture: View {
    var userName: String
    var avatar: String?
    @State private var image: UIImage?
    
    var body: some View {
        HStack() {
            HStack() {
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
            .frame(width: DisplayConstants.Sizes.imageSize.width, height: DisplayConstants.Sizes.imageSize.height)
            .background(DisplayConstants.Colors.backgroundColor)
            .cornerRadius(DisplayConstants.Sizes.imageSize.width / 2)
            .padding(0)
        }.task {
            if let avatar = avatar, let url = URL(string: avatar) {
                let image = try? await ImageService.getImage(url: url)
                await MainActor.run {
                    self.image = image
                }
            }
        }
    }
}
