import Foundation
import SwiftUI

private enum TweetViewConstants {
    struct Radii {
        static let cornerRadius = 20.0
        static let shadowRadius = 10.0
        static let imageRadius = 10.0
    }
    
    struct Image {
        static let sizeOfSide = 40.0
        static let placeholderImageName = "person"
    }
}

struct TweetView: View {
    @State var tweet: Tweet
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                AsyncImage(
                    url: tweet.avatarURL,
                    content: { image in
                        image.resizable()
                             .aspectRatio(contentMode: .fit)
                             .frame(width: TweetViewConstants.Image.sizeOfSide,
                                    height: TweetViewConstants.Image.sizeOfSide)
                    },
                    placeholder: {
                        Image(systemName: TweetViewConstants.Image.placeholderImageName)
                            .frame(width: TweetViewConstants.Image.sizeOfSide,
                                   height: TweetViewConstants.Image.sizeOfSide)
                    })
                    .cornerRadius(TweetViewConstants.Radii.imageRadius)
                Text(tweet.author)
                    .font(.subheadline)
                Spacer()
            }
            .padding()
            
            HStack {
                Text(tweet.content)
                    .font(.headline)
            }
            .padding()
            
            HStack {
                Text(tweet.date.formatted(date: .abbreviated, time: .standard))
                    .font(.caption2)
            }
            .padding()
        }
        .background {
            Color.green
                .clipShape(.rect(cornerRadii: .init(topLeading: TweetViewConstants.Radii.cornerRadius, 
                                            bottomLeading: TweetViewConstants.Radii.cornerRadius,
                                            bottomTrailing: TweetViewConstants.Radii.cornerRadius,
                                            topTrailing: TweetViewConstants.Radii.cornerRadius)))
                .shadow(radius: TweetViewConstants.Radii.shadowRadius)
        }
    }
}
