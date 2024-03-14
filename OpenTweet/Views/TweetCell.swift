//
//  TweetCell.swift
//  OpenTweet
//
//  Created by HU QI on 2024-03-13.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import UIKit

protocol TweetCellInterface {
    var userAvatarImageUrl: String? { get }
    var authorLabelText: String { get }
    var dateLabelText: String { get }
    var contentLabelAttributedText: NSMutableAttributedString { get }
}

final class TweetCell: UICollectionViewCell {
    static let reuseIdentifier: String = Constants.TweetCell.reuseIdentifier
    
    var onCellTapped: Completion?
    
    override var isSelected: Bool {
        didSet {
            if isSelected != oldValue {
                selectionAnimation(isSelected: isSelected)
            }
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            toggleIsHighlighted()
        }
    }
    
    private lazy var userAvatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Constants.TweetCell.avatarImageCornerRadius
        imageView.backgroundColor = .gray
        imageView.image = UIImage(systemName: "person.circle.fill")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemBlue
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addRoundedCorners()
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.transform = .identity
    }
    
    func setup(_ tweetCellViewModel: TweetCellInterface) {
        backgroundColor = .lightGray
        authorLabel.text = tweetCellViewModel.authorLabelText
        dateLabel.text = tweetCellViewModel.dateLabelText
        contentLabel.attributedText = tweetCellViewModel.contentLabelAttributedText
        
        if let avatarUrl = tweetCellViewModel.userAvatarImageUrl {
            userAvatarImageView.loadImageFromURL(urlString: avatarUrl)
        }
        
        layoutIfNeeded()
    }
    
    func setup(tweet: Tweet) {
        backgroundColor = .gray
        authorLabel.text = tweet.author
        dateLabel.text = tweet.date.description
        contentLabel.text = tweet.content
        
        if let avatarUrl = tweet.avatar {
            userAvatarImageView.loadImageFromURL(urlString: avatarUrl)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutConstraints()
    }
    
    private func selectionAnimation(isSelected: Bool) {
        UIView.animate(
            withDuration: 0.3,
            animations: { [weak self] in
                self?.transform = isSelected ? CGAffineTransform(scaleX: 1.05, y: 1.05) : .identity
            },
            completion: { [weak self] _ in
                if !isSelected {
                    self?.transform = .identity
                } else {
                    self?.onCellTapped?()
                    self?.isSelected = false
                }
            })
    }
    
    private func toggleIsHighlighted() {
        UIView.animate(
            withDuration: 0.1,
            delay: 0,
            options: [.curveEaseOut],
            animations: {
                self.alpha = self.isHighlighted ? 0.9 : 1.0
            }
        )
    }
    
    private func addSubviews() {
        addSubview(userAvatarImageView)
        addSubview(authorLabel)
        addSubview(dateLabel)
        addSubview(contentLabel)
    }
    
    private func addRoundedCorners() {
        contentView.layer.cornerRadius = Constants.Dimens.cellCornerRadius
        contentView.layer.masksToBounds = true
        
        layer.cornerRadius = Constants.Dimens.cellCornerRadius
        layer.masksToBounds = false
    }
    
    private func layoutConstraints() {
        let constraints: [NSLayoutConstraint] = [
            userAvatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.Dimens.padding),
            userAvatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.Dimens.padding),
            userAvatarImageView.heightAnchor.constraint(equalToConstant: Constants.TweetCell.avatarImageHeight),
            userAvatarImageView.widthAnchor.constraint(equalToConstant: Constants.TweetCell.avatarImageWidth),
            
            authorLabel.leadingAnchor.constraint(equalTo: userAvatarImageView.trailingAnchor, constant: Constants.Dimens.padding),
            authorLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.Dimens.padding),
            authorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.Dimens.padding),
            
            dateLabel.leadingAnchor.constraint(equalTo: authorLabel.leadingAnchor),
            dateLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: Constants.Dimens.padding),
            dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.Dimens.padding),
            
            contentLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.Dimens.padding),
            contentLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.Dimens.padding),
            contentLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.Dimens.padding)
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        let contentLabelTopConstraintOne = contentLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: Constants.Dimens.padding)
        contentLabelTopConstraintOne.priority = .defaultLow
        contentLabelTopConstraintOne.isActive = true
        
        let contentLabelTopConstraintTwo = contentLabel.topAnchor.constraint(greaterThanOrEqualTo: userAvatarImageView.bottomAnchor, constant: Constants.Dimens.padding)
        contentLabelTopConstraintTwo.priority = .required
        contentLabelTopConstraintTwo.isActive = true
    }
}
