//
//  TimelineTableViewController.swift
//  OpenTweet
//
//  Created by Jesper Rage on 2024-02-05.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import UIKit
import RegexBuilder

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var replyCountLabel: UILabel!
    @IBOutlet weak var replyBubble: UIImageView!
    @IBOutlet weak var replyLabel: UILabel!
}

class TimelineTableViewController: UITableViewController {
    var focusedTimelineOnTweet: Tweet? // Set if controller is showing replies for Tweet
    var timeline: Timeline = Timeline(timeline: [Tweet]())
    var avatarCache = [URL: UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Update colours
        view.backgroundColor = theme.background
        tableView.backgroundColor = theme.background
        tableView.separatorColor = theme.trim
        
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeline.timeline.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        

        // Configure the cell...
        let tweet = timeline.timeline[indexPath.row]
        
        // Get Avatar
        Task {
            do {
                cell.avatarImageView.image = try await avatar(for: tweet)
            } catch {
                print("Error cell for indexPath \(indexPath) \(error.localizedDescription)")
            }
        }
        
        // Round image view / Give default colour for non avatar users
        cell.avatarImageView.contentMode = .scaleAspectFill
        cell.avatarImageView.layer.borderWidth = 1
        cell.avatarImageView.layer.masksToBounds = false
        cell.avatarImageView.layer.borderColor = UIColor.black.cgColor
        cell.avatarImageView.layer.cornerRadius = cell.avatarImageView.frame.height/2
        cell.avatarImageView.clipsToBounds = true
        cell.avatarImageView.backgroundColor = .tintColor
        
        // Author
        cell.authorLabel.text = tweet.author
        
        // Reply
        if let inReplyTo = timeline.originalPost(inReplyTo: tweet) {
            cell.replyLabel.text = "In reply to " + inReplyTo.author
        } else {
            cell.replyLabel.text = ""
        }
        
        // Date label
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        formatter.string(from: tweet.date)
        cell.dateLabel.text = " - " + formatter.string(from: tweet.date)
        
        // set message
        cell.messageTextView.text = tweet.content
        var attributedString = NSMutableAttributedString(string: tweet.content)
        let range = NSRange(location: 0, length: attributedString.length)
        
        // Set all text to AppTheme colour
        attributedString.addAttribute(.foregroundColor, value: theme.textBody, range: range)

        // Search for links in the text
        let types: NSTextCheckingResult.CheckingType = .link
        let detector = try? NSDataDetector(types: types.rawValue)

        if let detect = detector {
        
            let matches = detect.matches(in: tweet.content, options: .reportCompletion, range: NSMakeRange(0, tweet.content.count))
            
            // For every link highlight only the link
            for match in matches {
                attributedString.addAttribute(.foregroundColor, value: theme.textHighlight, range: match.range)
            }
        }
        
        // Search for Authors mentions
        let authorSearch = Regex {
            "@"
            Capture {
                OneOrMore(.word)
            }
        }
        
        let matches = tweet.content.matches(of: authorSearch)
        for match in matches {
            
            // Fastest way I could figure how to convert Range<String.Index> to NSRange
            // Regex returns confirmed match strings, so search for the NSRange from the NSSTring that you know has the string
            let range = NSString(string: tweet.content).range(of: String(match.output.0))
        
            attributedString.addAttribute(.foregroundColor, value: theme.textHighlight, range: range)
        
        }
        attributedString.addAttribute(.font, value: theme.bodyFont, range: range)
        
        // Set messageView the now complicated attributed string
        cell.messageTextView.attributedText = attributedString
        
        
        // set reply count
        if let replies = timeline.getReplies(to: tweet) {
            cell.replyCountLabel.text = "\(replies.count)"
        } else {
            cell.replyCountLabel.text = ""
        }
        
        // Update Theme
        cell.authorLabel.textColor = theme.textTitle
        cell.authorLabel.font = theme.titleFont
        cell.replyLabel.textColor = theme.textBody
        cell.replyLabel.font = theme.replyFont
        cell.dateLabel.textColor = theme.textBody
        cell.dateLabel.font = theme.dateFont
        cell.contentView.backgroundColor = theme.background
        cell.replyBubble.tintColor = theme.trim
        cell.replyCountLabel.textColor = theme.trim
        cell.replyCountLabel.font = theme.replyCountFont
        
        return cell
    }

    // Selecting a tweet will push a new timeline of the replies to that tweet
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // get tweet
        let tweet = timeline.timeline[indexPath.row]
        
        // Stop double select
        guard focusedTimelineOnTweet?.id != tweet.id else {
            return
        }
        
        // get replies
        var nestedTimeline = Timeline(timeline: [tweet])
        if let replies = timeline.getReplies(to: tweet)  {
            nestedTimeline.timeline += replies
        }
        
        let storyboard = UIStoryboard(name:"Main", bundle: nil)
        let nestedReplyTimeline = storyboard.instantiateViewController(withIdentifier: "TimelineTableViewController") as! TimelineTableViewController
       
        // Push a timeline with just the reply content
        nestedReplyTimeline.timeline = nestedTimeline
        nestedReplyTimeline.focusedTimelineOnTweet = tweet
        nestedReplyTimeline.avatarCache = avatarCache
        self.navigationController?.pushViewController (nestedReplyTimeline, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    
    // Returns avatar from cache, if its not there it attempts downloading
    func avatar(for tweet: Tweet) async throws -> UIImage? {
        if let avatar = tweet.avatar {
            if let url = URL(string: avatar) {
                
                if let image = avatarCache[url] {
                    return image
                } else {
                    
                    let imageData = try await self.downloadAvatarData(from: url)
                    guard let avatar = UIImage(data: imageData) else {
                        throw NSError(domain: "failed to load avatar image", code: 0, userInfo: nil)
                    }
                    self.avatarCache[url] = avatar
                    return avatar
                }
            }
        }
        return nil
    }
    
    func downloadAvatarData(from url: URL) async throws -> Data {
        let request = URLRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)
        return data
    }
}
