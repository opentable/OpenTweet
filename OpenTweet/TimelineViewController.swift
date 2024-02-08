//
//  ViewController.swift
//  OpenTweet
//
//  Created by Olivier Larivain on 9/30/16.
//  Copyright © 2016 OpenTable, Inc. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController {
    @IBOutlet weak var timelineView: UITableView!
    @IBOutlet weak var spinnerView: UIActivityIndicatorView!

    let model = TimelineModel()

	override func viewDidLoad() {
		super.viewDidLoad()

        timelineView.dataSource = model
        timelineView.delegate = self
        timelineView.alpha = 0

        updateTitle()
        refreshModel()
	}

    /// Refresh the model
    func refreshModel() {
        // This is pretty old-school imperative stuff, but setting up a more
        // reactive architecture isn't trivial.
        showSpinner()
        model.fetch { [weak self] result in
            switch result {
            case .failure(let error):
                self?.handleError(error) {
                    DispatchQueue.main.async { [weak self] in self?.refreshModel() }
                }
            case .success:
                self?.hideSpinner()
            }

            self?.timelineView.reloadData()
            self?.updateTitle()
        }
    }

    /// Basic UIAlert wrapper for when things go wrong. If retryAction is
    /// provided, a "Retry" button will be added, with the provided closure
    /// executed when Retry is chosen.
    func handleError(_ error: Swift.Error, retryAction: (() -> Void)? = nil ) {
        let title = NSLocalizedString("Error", comment: "Title for generic error message")
        let okTitle = NSLocalizedString("OK", comment: "Title for OK button")
        let retryTitle = NSLocalizedString("Retry", comment: "Title for a retry button")
        let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: okTitle, style: .default))

        if let retry = retryAction {
            let a = UIAlertAction(title: retryTitle, style: .cancel) { _ in
                retry()
            }
            alert.addAction(a)
        }
    }

    // Loading spinner
    func showSpinner() {
        DispatchQueue.main.async { [weak self] in
            self?.spinnerView.startAnimating()
            UIView.animate(withDuration: 0.3) {
                self?.timelineView.alpha = 0
                self?.spinnerView.alpha = 1
            }
        }
    }

    func hideSpinner() {
        DispatchQueue.main.async { [weak self] in
            UIView.animate(withDuration: 0.3) {
                self?.timelineView.alpha = 1
                self?.spinnerView.alpha = 0
            }
        }
    }

    /// Updates this VC's title for display in the enclosing navigation controller
    private func updateTitle() {
        title = model.isRootThread
            ? NSLocalizedString("Timeline", comment: "UI title for the main timeline view")
            : NSLocalizedString("Thread", comment: "UI title for a thread view ")
    }
}

extension TimelineViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 1, // Disallow taps on root thread tweet
              model.isRootThread,     // Disallow going deep into threads
              let cell = tableView.cellForRow(at: indexPath) as? TimelineViewCell,
              let tweet = cell.data,
              let threadRoot = model.threadRootID(tweet: tweet)
        else { return }

        let pushVC = { [weak self] in
            let vc = UIStoryboard(name: "Main", bundle: Bundle(for: TimelineViewController.self))
                .instantiateViewController(withIdentifier: "timeline") as! TimelineViewController
            vc.model.currentThreadRoot = threadRoot
            self?.navigationController?.pushViewController(vc, animated: true)
        }

        // Enlarge the selected cell a bit before pushing the next VC
        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseOut]) {
            cell.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        } completion: { _ in
            pushVC()
            UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseIn]) {
                cell.transform = .identity
            } completion: { _ in }
        }
    }
}

class TimelineViewCell: UITableViewCell {
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var chevronView: UIImageView!
    @IBOutlet private weak var replyCountLabel: UILabel!

    var data: Tweet? = nil {
        didSet {
            guard let data = data else {
                // No idea why, but this is stomping on images set AFTER the
                // prepareForReuse call. It's probably some stupid thread race that
                // I'm not going to chase right now, as it doesn't make a practical
                // difference for this example. But that's why this is commented out.
//                avatarView.image = nil
                authorLabel.text = nil
                contentLabel.text = nil
                dateLabel.text = nil
                replyCount = 0
                isThreadRoot = false
                hasThread = false
                return
            }

            authorLabel.text = data.author
                .trimmingCharacters(in: CharacterSet(charactersIn: "@"))

            contentLabel.attributedText = attributedString(content: data.content)
            dateLabel.text = dateString(date: data.date)
        }
    }

    var hasThread: Bool = false {
        didSet { chevronView.isHidden = !hasThread }
    }

    var replyCount: Int = 0 {
        didSet { replyCountLabel.text = replyCountString(replyCount: replyCount) }
    }

    var isThreadRoot: Bool = false {
        didSet {
            backgroundColor = isThreadRoot ? .secondarySystemBackground : .clear
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        // No idea why, but this is stomping on images set AFTER the
        // prepareForReuse call. It's probably some stupid thread race that
        // I'm not going to chase right now, as it doesn't make a practical
        // difference for this example. But that's why this is commented out.
//        avatarView.image = UIImage(systemName: "person.crop.circle")
        data = nil
        backgroundColor = .clear
    }

    // MARK: Data Formatting

    /// Highlights user mentions in a content string
    private func attributedString(content: String, mentionColor: UIColor = .blue) -> NSAttributedString {
        // Split the tweet content into tokens, mark each as a user mention or
        // not, map that to attributed strings of the appropriate color, then
        // smash it back together

        // TODO: A regex would be better here. Not sure why I did the split / join thing.
        let content = content.split(separator: " ")
            .map { token -> (Bool, String) in
                token.first == "@" ? (true, String(token)) : (false, String(token))
            }.map { isUserMention, token -> NSMutableAttributedString in
                let s = NSMutableAttributedString(string: token)
                if isUserMention {
                    s.addAttribute(.foregroundColor,
                                   value: mentionColor,
                                   range: NSRange(location: 0, length: token.count))
                }
                return s
            }

        // This results in a trailing space...
        return content.reduce(into: NSMutableAttributedString()) {
            $0.append($1)
            $0.append(NSAttributedString(string: " "))
        }
    }

    /// Short-format dates for UI display
    private func dateString(date: Date) -> String {
        // TODO: Would be nice to have friendly dates, i.e. "Just Now", "20 Minutes Ago"
        // TODO: I assume the JSON timestamps are UTC? Would be nice to show in local time
        let f = DateFormatter()
        f.dateStyle = .short
        f.timeStyle = .short
        f.formatterBehavior = .behavior10_4
        return f.string(from: date)
    }

    /// Reply Count for UI display. Nil if count == 0
    private func replyCountString(replyCount: Int) -> String? {
        if replyCount > 0 {
            let replyString = NSLocalizedString("reply", comment: "")
            let repliesString = NSLocalizedString("replies", comment: "")
            return "\(replyCount) \(replyCount == 1 ? replyString : repliesString)"
        } else {
            return nil
        }
    }
}

/// Convenience wrapper around UIImageView that provides a circular frame
class AvatarView: UIImageView {
    override var bounds: CGRect {
        didSet {
            layer.cornerRadius = max(bounds.width, bounds.height) * 0.5
        }
    }
}
