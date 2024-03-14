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
        static let url = /https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,4}\b([-a-zA-Z0-9@:%_\+.~#?&\/\/=]*)/
    }
    
    static let colours: [Color] = [.cyan, .teal, .pink, .purple, .orange, .red, .yellow]
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
                if let highlightedMentions = [highlightMentions(from: NSMutableAttributedString(string: tweet.content))].map({ highlightLinks(from: NSMutableAttributedString($0))}).first {
                    Text(highlightedMentions)
                        .font(.subheadline)
                } else {
                    Text(tweet.content)
                        .font(.subheadline)
                }
                
                
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
    
    private func highlightMentions(from attributedText: NSMutableAttributedString) -> AttributedString {
        let mentionRegex = TweetViewConstants.Regex.mentions
        var textFullyAttributed = AttributedString(attributedText)
        
        let mentions = attributedText.string.matches(of: mentionRegex)
        
        for mention in mentions {
            guard let existingAttributedRange = textFullyAttributed.range(of: mention.output) else { continue }
            
            textFullyAttributed[existingAttributedRange].foregroundColor = .green
            textFullyAttributed[existingAttributedRange].underlineStyle = .single
            textFullyAttributed[existingAttributedRange].underlineColor = .green
        }
        
        return textFullyAttributed
    }
    
    private func highlightLinks(from attributedText: NSMutableAttributedString) -> AttributedString {
        let urlRegex = TweetViewConstants.Regex.url
        var textFullyAttributed = AttributedString(attributedText)

        let urls = attributedText.string.matches(of: urlRegex)
        
        for url in urls {
            guard let existingAttributedRange = textFullyAttributed.range(of: url.output.0) else { continue }
            
            textFullyAttributed[existingAttributedRange].foregroundColor = Color.blue
            textFullyAttributed[existingAttributedRange].underlineStyle = .single
            textFullyAttributed[existingAttributedRange].underlineColor = .blue
            textFullyAttributed[existingAttributedRange].link = URL(string: String(url.output.0))
        }
        
        return textFullyAttributed
    }
}
