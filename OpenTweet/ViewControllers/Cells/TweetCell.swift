//
//  TweetCell.swift
//  OpenTweet
//
//  Created by David Auld on 2024-03-12.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import Foundation
import UIKit

class TweetCell: UICollectionViewCell {
  static let identifier: String = "TweetCell"
  
  let view = TweetView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    view.translatesAutoresizingMaskIntoConstraints = false
    addSubview(view)
    NSLayoutConstraint.activate([
      view.topAnchor.constraint(equalTo: topAnchor, constant: 0),
      view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
      view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
      view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0)
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    view.reset()
  }
  
  func configure(tweet: Tweet) {
    view.configure(tweet: tweet)
  }
}

class TweetView: UIView {
  private var authorLabel: UILabel = {
    let label = UILabel()
    label.adjustsFontForContentSizeCategory = true
    label.font = UIFont.preferredFont(forTextStyle: .body)
    label.numberOfLines = 1
    label.lineBreakMode = .byWordWrapping
    label.textColor = UIColor.label
    return label
  }()
  
  private var contentLabel: UILabel = {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .body)
    label.numberOfLines = 0
    label.lineBreakMode = .byWordWrapping
    label.textColor = UIColor.secondaryLabel
    return label
  }()
  
  private var timestampLabel: UILabel = {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .footnote)
    label.numberOfLines = 1
    label.lineBreakMode = .byWordWrapping
    label.textColor = UIColor.tertiaryLabel
    return label
  }()
  
  private var avatarImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.backgroundColor = .gray
    imageView.layer.cornerRadius = 20
    imageView.image = UIImage(systemName: "person.fill")
    return imageView
  }()
  
  private lazy var stackView: UIStackView = {
    let stack = UIStackView(arrangedSubviews: [authorLabel, timestampLabel, contentLabel])
    stack.axis = .vertical
    stack.alignment = .fill
    stack.spacing = 5.0
    stack.translatesAutoresizingMaskIntoConstraints = false
    return stack
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.backgroundColor = .secondarySystemBackground
    self.layer.cornerRadius = 12
    self.layer.shadowRadius = 2
    self.layer.shadowOpacity = 0.1
    self.layer.shadowOffset = CGSize(width: 0, height: 4)
    self.layer.masksToBounds = false
    
    self.addSubview(avatarImageView)
    self.addSubview(stackView)
    
    NSLayoutConstraint.activate([
      avatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
      avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
      avatarImageView.widthAnchor.constraint(equalToConstant: 40),
      avatarImageView.heightAnchor.constraint(equalToConstant: 40),
      avatarImageView.bottomAnchor.constraint(lessThanOrEqualTo: stackView.bottomAnchor, constant: 0),
      stackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
      stackView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 10),
      stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
      stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
    ])
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    let shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
    
    self.layer.shadowPath = shadowPath
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(tweet: Tweet) {
    authorLabel.text = tweet.author
    timestampLabel.text = tweet.date.timelineTimestamp()
    contentLabel.attributedText = styledAttributedString(for: tweet.content)
    if let avatar = tweet.avatar, let avatarUrl = URL(string: avatar) {
      avatarImageView.loadImage(from: avatarUrl)
    } else {
      avatarImageView.image = .init(systemName: "person.fill")
      avatarImageView.tintColor = hashStringToColor(tweet.author)
    }
  }
  
  func reset() {
    avatarImageView.image = nil
    avatarImageView.tintColor = nil
  }
  
  private func styledAttributedString(for content: String) -> NSAttributedString {
    let stringBuilder = AttributedStringBuilder(string: content)
    
    let detectors: [(detector: TextPatternDetector, color: UIColor)] = [
      (MentionDetector(), .systemBlue),
      (LinkDetector(), .systemBlue)
    ]
    
    for (detector, color) in detectors {
      let matches = detector.matches(in: content)
      matches.forEach { match in
        stringBuilder.attributedString.addAttributes([.foregroundColor: color], range: match.range)
      }
    }
    
    return stringBuilder.attributedString
  }
  
  private func hashStringToColor(_ input: String) -> UIColor {
    let scaleFactor = 0.6 // Adjust for darker (0) to lighter (1) colors
    let hash = input.hashValue
    let red = CGFloat((hash & 0xFF0000) >> 16) / 255.0 * scaleFactor
    let green = CGFloat((hash & 0x00FF00) >> 8) / 255.0 * scaleFactor
    let blue = CGFloat(hash & 0x0000FF) / 255.0 * scaleFactor
    return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
  }
}
