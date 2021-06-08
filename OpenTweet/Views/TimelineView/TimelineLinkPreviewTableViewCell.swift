//
//  TimelineLinkPreviewTableViewCell.swift
//  OpenTweet
//
//  Created by Sherman Shi on 5/15/21.
//  Copyright © 2021 OpenTable, Inc. All rights reserved.
//

import UIKit
import LinkPresentation

class TimelineLinkPreviewTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "TimelineLinkPreviewTableViewCell"
    
    // MARK: - Properties
    
    lazy var avatar: UIImageView = {
        let iv = UIImageView()
        return iv.configureAvatarImageView()
    }()
    
    lazy var usernameButton: UIButton = {
        let button = UIButton()
        return button.configureUsernameButton()
    }()
    
    lazy var timestamp: UILabel = {
        let label = UILabel()
        return label.configureTimestampLabel()
    }()
    
    lazy var content: UITextView = {
        let tv = UITextView()
        return tv.configureContentTextView()
    }()
    
    lazy var linkPreview: LPLinkView = {
        let lp = LPLinkView()
        return lp
    }()
    
    // MARK: - Closures
    
    var usernameButtonTapped: (() -> Void)?

    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViewCellComponents()
        configureButtonActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper Functions
    
    func configureButtonActions() {
        usernameButton.addTarget(self, action: #selector(handleUsernameButtonTapped), for: .touchUpInside)
    }
    
    private func configureViewCellComponents() {
        backgroundColor = K.Colors.white
        
        // Set a custom selection color
        let backgroundView = UIView()
        backgroundView.backgroundColor = K.Colors.lightGray
        selectedBackgroundView = backgroundView

        let defaultPadding = K.Layout.defaultSidePadding()
        let halfPadding: CGFloat = 8
        let minimumPadding: CGFloat = 4
        let avatarSize: CGFloat = 50
        
        // Auto-Layout constraints
        
        contentView.addSubview(avatar)
        avatar.anchorWithConstant(top: contentView.topAnchor,
                                  bottom: nil,
                                  leading: contentView.leadingAnchor,
                                  trailing: nil,
                                  paddingTop: halfPadding,
                                  paddingBottom: 0,
                                  paddingLeading: defaultPadding,
                                  paddingTrailing: 0,
                                  width: avatarSize,
                                  height: avatarSize)
        avatar.layer.cornerRadius = avatarSize / 2
        
        contentView.addSubview(usernameButton)
        usernameButton.anchorWithConstant(top: avatar.topAnchor,
                                          bottom: nil,
                                          leading: avatar.trailingAnchor,
                                          trailing: contentView.trailingAnchor,
                                          paddingTop: 0,
                                          paddingBottom: 0,
                                          paddingLeading: halfPadding,
                                          paddingTrailing: defaultPadding,
                                          width: 0,
                                          height: 0)
        
        contentView.addSubview(timestamp)
        timestamp.anchorWithConstant(top: usernameButton.bottomAnchor,
                                     bottom: nil,
                                     leading: usernameButton.leadingAnchor,
                                     trailing: usernameButton.trailingAnchor,
                                     paddingTop: minimumPadding,
                                     paddingBottom: 0,
                                     paddingLeading: 0,
                                     paddingTrailing: 0,
                                     width: 0,
                                     height: 0)
        
        contentView.addSubview(content)
        content.anchorWithConstant(top: timestamp.bottomAnchor,
                                   bottom: nil,
                                   leading: usernameButton.leadingAnchor,
                                   trailing: usernameButton.trailingAnchor,
                                   paddingTop: minimumPadding,
                                   paddingBottom: 0,
                                   paddingLeading: 0,
                                   paddingTrailing: 0,
                                   width: 0,
                                   height: 0)
        
        contentView.addSubview(linkPreview)
        linkPreview.anchorWithConstant(top: content.bottomAnchor,
                                       bottom: contentView.bottomAnchor,
                                       leading: usernameButton.leadingAnchor,
                                       trailing: usernameButton.trailingAnchor,
                                       paddingTop: halfPadding,
                                       paddingBottom: halfPadding,
                                       paddingLeading: 0,
                                       paddingTrailing: 0,
                                       width: 0,
                                       height: 250)
    }
}

// MARK: - Cell Configuration With Timeline Data

extension TimelineLinkPreviewTableViewCell {
    func configureCellWithLinkPreview(with timelineTweet: TimelineTweet, hyperlink: URL?) {
        usernameButton.setTitle(timelineTweet.author, for: .normal)
        timestamp.text = timestampConverter(timestamp: timelineTweet.date)
        content.text = timelineTweet.content
        
        // If timeline tweet data contains avatar data, parse image data, otherwise use default image
        if timelineTweet.avatar != nil {
            guard let avatarURLString = timelineTweet.avatar else { return }
            guard let avatarURL = URL(string: avatarURLString) else { return }
            avatar.downloadImage(from: avatarURL)
        } else {
            avatar.image = K.Images.openTable
        }
        
        // Fetching metadata from hyperlink to present a Link Preview
        if let hyperlink = hyperlink {
            let linkPreview = LPLinkView()
            let provider = LPMetadataProvider()
            provider.startFetchingMetadata(for: hyperlink) { metadata, error in
                guard let data = metadata, error == nil else {
                    print("Error when loading link preview.")
                    return
                }
                
                DispatchQueue.main.async {
                    linkPreview.metadata = data
                }
            }
        }
    }
}

// MARK: - Selectors

extension TimelineLinkPreviewTableViewCell {
    @objc func handleUsernameButtonTapped() {
        usernameButtonTapped?()
    }
}
