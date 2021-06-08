//
//  TimelineTableView.swift
//  OpenTweet
//
//  Created by Sherman Shi on 5/15/21.
//  Copyright © 2021 OpenTable, Inc. All rights reserved.
//

import UIKit

class TimelineTableView: UITableView, ContextMenu {

    // MARK: - Properties
    
    weak var transitionToTimelineDetailViewControllerDelegate: TransitionToTimelineDetailViewControllerDelegate?
    weak var transitionToUserProfileViewControllerDelegate: TransitionToUserProfileViewControllerDelegate?
    weak var alertDelegate: AlertDelegate?
    
    var timelineData: TimelineData?
    
    // MARK: - Initializers
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        configureTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper Functions
    
    private func configureTableView() {
        delegate = self
        dataSource = self
        register(TimelineTableViewCell.self, forCellReuseIdentifier: TimelineTableViewCell.reuseIdentifier)
        register(TimelineLinkPreviewTableViewCell.self, forCellReuseIdentifier: TimelineLinkPreviewTableViewCell.reuseIdentifier)
        backgroundColor = K.Colors.white
        showsVerticalScrollIndicator = false
        
        // Setting the background color to white
        let bgView = UIView()
        bgView.backgroundColor = K.Colors.white
        backgroundView = bgView
        tableFooterView = UIView()
        separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        // Top separator line for first cell
        let pixel = 1 / UIScreen.main.scale
        let line = UIView(frame: CGRect(x: 0, y: 0, width: K.Layout.screenWidth, height: pixel))
        tableHeaderView = line
        line.backgroundColor = separatorColor
    }
}

/* Tableview Delegate and Data Source */
extension TimelineTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        timelineData?.timeline.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let regularCell = tableView.dequeueReusableCell(withIdentifier: TimelineTableViewCell.reuseIdentifier, for: indexPath) as! TimelineTableViewCell
        let linkPreviewCell = tableView.dequeueReusableCell(withIdentifier: TimelineLinkPreviewTableViewCell.reuseIdentifier, for: indexPath) as! TimelineLinkPreviewTableViewCell
        
        if let timelineData = timelineData?.timeline[indexPath.row] {
            let hyperlink = linkCheck(with: timelineData.content)
            // If no hyperlink exists, dequeue a regular cell, otherwise dequeue custom cell with link preview
            if hyperlink == nil {
                regularCell.configureCell(with: timelineData)
                // Closure that returns a button tap action, which then triggers a navigation push to the author's profile page, passing along their @username
                regularCell.usernameButtonTapped = {
                    self.transitionToUserProfileViewControllerDelegate?.presentUserProfileViewController(with: timelineData.author)
                }
                return regularCell
            } else {
                linkPreviewCell.configureCellWithLinkPreview(with: timelineData, hyperlink: hyperlink)
                // Closure that returns a button tap action, which then triggers a navigation push to the author's profile page, passing along their @username
                linkPreviewCell.usernameButtonTapped = {
                    self.transitionToUserProfileViewControllerDelegate?.presentUserProfileViewController(with: timelineData.author)
                }
                return linkPreviewCell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if let tweet = timelineData?.timeline[indexPath.row] {
            
            var detailedTimelineTweet = [TimelineTweet]()
            
            // Filter data by matching "inReplyTo" property to tweet's "id" property to see if selected post has a reply
            // If post has a reply, append to the array placeholder above
            if let repliesArray = timelineData?.timeline.filter({ $0.inReplyTo == tweet.id }) {
                detailedTimelineTweet.append(tweet)
                detailedTimelineTweet.append(contentsOf: repliesArray)
            }
            
            // Locate the main tweet of the selected tweet, if there is one, append to the beginning of the array placeholder
            // Otherwise if none, this will be skipped
            if let mainTweet = timelineData?.timeline.first(where: { $0.id == tweet.inReplyTo }) {
                detailedTimelineTweet.insert(mainTweet, at: 0)
            }

            // Delegate method to trigger tweet detail transition
            transitionToTimelineDetailViewControllerDelegate?.presentDetailViewController(with: detailedTimelineTweet)
        }
    }
}

// MARK: - Context Menus

extension TimelineTableView {
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        // Creating context menus for each row, more details to each action in the protocol
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { actions in
            let author = self.timelineData?.timeline[indexPath.row].author
            return self.configureDefaultContextMenu(blockAuthor: author ?? "User")
        }
    }
}

// MARK: - Hyperlink Check

extension TimelineTableView {
    private func linkCheck(with contentString: String) -> URL? {
        // Check for possible URL link
        let type: NSTextCheckingResult.CheckingType = .link
        let linkDetector = try? NSDataDetector(types: type.rawValue)
        
        var hyperlink: URL?
        // If URL link is detect, return it
        if let detected = linkDetector {
            let matches = detected.matches(in: contentString, options: .reportCompletion, range: NSMakeRange(0, contentString.count))

            for match in matches {
                hyperlink = match.url
            }
        }
        return hyperlink
    }
}
