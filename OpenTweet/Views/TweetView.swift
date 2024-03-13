import Foundation
import SwiftUI
import RegexBuilder

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
    
    struct Regex {
        static let mentions = /[@]\w+/
    }
    
    static let colours: [Color] = [.green, .blue, .pink, .purple, .orange, .red, .yellow]
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
                    .font(.headline)
                Spacer()
            }
            .padding()
            
            HStack {
                Text(highlightMentions(from: tweet.content))
                    .font(.subheadline)
            }
            .padding()
            
            HStack {
                Text(tweet.date.formatted(date: .abbreviated, time: .standard))
                    .font(.caption2)
            }
            .padding()
        }
        .background {
            TweetViewConstants.colours.randomElement()
                .clipShape(.rect(cornerRadii: .init(topLeading: TweetViewConstants.Radii.cornerRadius,
                                            bottomLeading: TweetViewConstants.Radii.cornerRadius,
                                            bottomTrailing: TweetViewConstants.Radii.cornerRadius,
                                            topTrailing: TweetViewConstants.Radii.cornerRadius)))
                .shadow(radius: TweetViewConstants.Radii.shadowRadius)
        }
    }
    
    private func highlightMentions(from text: String) -> AttributedString {
        let mentionRegex = TweetViewConstants.Regex.mentions
        var textFullyAttributed = AttributedString(text)
        
        let mentions = text.matches(of: mentionRegex)
        
        for mention in mentions {
            guard let existingAttributedRange = textFullyAttributed.range(of: mention.output) else { continue }
            
            textFullyAttributed[existingAttributedRange].foregroundColor = Color.indigo
            textFullyAttributed[existingAttributedRange].underlineStyle = .single
            textFullyAttributed[existingAttributedRange].underlineColor = .magenta
        }
        
        return textFullyAttributed
    }
    
    private func highlightLinks(from text: String) -> AttributedString {
        let mentionRegex = TweetViewConstants.Regex.mentions
        var textFullyAttributed = AttributedString(text)
        
        let mentions = text.matches(of: mentionRegex)
        
        for mention in mentions {
            guard let existingAttributedRange = textFullyAttributed.range(of: mention.output) else { continue }
            
            textFullyAttributed[existingAttributedRange].foregroundColor = Color.indigo
            textFullyAttributed[existingAttributedRange].underlineStyle = .single
            textFullyAttributed[existingAttributedRange].underlineColor = .magenta
        }
        
        return textFullyAttributed
    }
}
