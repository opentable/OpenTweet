import UIKit

class TimelineModel: NSObject {
    static let shared = TimelineModel()

    private var lastResult: Result<Timeline, Swift.Error>?

    var isRootThread: Bool { return currentThread?.root == nil }

    var currentThreadRoot: Tweet.ID?

    var currentThread: Thread? { return thread(forID: currentThreadRoot) }

    private var data: Timeline? {
        if let lastResult = lastResult, case .success(let data) = lastResult {
            return data
        }
        return nil
    }

    func fetch(completion: @escaping (Result<Timeline, Swift.Error>) -> Void) {
        api.fetchTimeline(completion: { [weak self] result in
            DispatchQueue.main.async {
                // Popping this back to main ensures any view updates aren't
                // happening simultaneously with state chagnes... which would
                // be very, very bad.
                self?.lastResult = result
                completion(result)
            }
        })
    }

    // For purposes of modeling data here, we'll just use Thread as the data
    // type behind the timeline, and treat threads with no root tweet as
    // being the "root" thread, or the timeline of everything. That way, we can
    // more or less recycle this view controller's essential components without
    // repeating ourselves. Might not work for more complex examples. idk.
    func thread(forID id: Tweet.ID?) -> Thread? {
        guard let id = id else { return timelineThread() }

        guard let root = data?.timeline
            .filter({ $0.id == id })
            .first
        else { return nil }

        guard let replies = replies(forID: id)
        else { return nil }

        return Thread(root: root, tweets: replies)
    }

    /// Generate an array of tweets replying to this tweet. Nil if no replies.
    func replies(forID id: Tweet.ID) -> [Tweet]? {
        guard let replies = data?.timeline
            .filter({ $0.inReplyTo == id })
            .sortedByDate()
        else { return nil }

        return replies.isEmpty ? nil : replies
    }

    /// The "Timeline" thread, or root thread
    func timelineThread() -> Thread? {
        guard let replies = data?.timeline
        else { return nil }
        return Thread(root: nil, tweets: replies)
    }

    /// If this tweet is part of a thread, returns the root tweet for that
    /// thread. If this is the beginning of a thread, returns this tweet, else,
    /// returns the tweet this tweet is replying to
    func threadRootID(tweet: Tweet) -> Tweet.ID? {
        // If this is a reply, then the original tweet is the thread root
        var threadRoot = tweet.inReplyTo
        // ...otherwise, if this thread has replies, then THIS thred is the root
        if threadRoot == nil,
           let thread = thread(forID: tweet.id),
           !thread.tweets.isEmpty {
            threadRoot = thread.root?.id
        }
        return threadRoot
    }
}

extension TimelineModel: UITableViewDataSource {
    enum ReuseID {
        static let timelineCell = "TimelineCell"
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return currentThread?.root == nil ? 0 : 1
        case 1: return currentThread?.tweets.count ?? 0
        default: fatalError()
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReuseID.timelineCell, for: indexPath) as? TimelineViewCell
        else { fatalError() }

        var maybeTweet: Tweet?
        switch indexPath.section {
        case 0: maybeTweet = currentThread?.root
        case 1: maybeTweet = currentThread?.tweets[indexPath.row]
        default: break
        }

        guard let tweet = maybeTweet
        else {
            // We're out of sync, so reload
            DispatchQueue.main.async {
                tableView.reloadData()
            }
            return cell
        }

        let replies = replies(forID: tweet.id) ?? []

        cell.data = tweet
        cell.isThreadRoot = indexPath.section == 0
        cell.replyCount = replies.count

        let hasReplies = !replies.isEmpty
        let isAReply = tweet.inReplyTo != nil
        cell.hasThread = hasReplies || isAReply

        if let avatarURL = tweet.avatar {
            AvatarService.shared.fetchAvatar(url: avatarURL, userID: tweet.author) { result in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let image):
                    DispatchQueue.main.async {
                        cell.avatarView.image = image
                    }
                }
            }
        }

        return cell
    }
}

