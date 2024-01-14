//
//  TimelineTableViewCell.swift
//  OpenTweet
//
//  Created by Dante Li on 2024-01-14.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import UIKit

final class TimelineTableViewCell: UITableViewCell {
    
    var tweet: Tweet? {
        didSet {
            nameLabel.text = tweet?.author
            timeLabel.text = tweet?.formattedDateString
            contentLabel.text = tweet?.content
            if let avatarData = tweet?.avatarData {
                avatarImageView.image = UIImage(data: avatarData)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Subviews and setup
    
    private let avatarWidth: Double = 30.0
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15.0, weight: .bold)
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12.0, weight: .light)
        return label
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: avatarWidth).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: avatarWidth).isActive = true
        imageView.layer.cornerRadius = avatarWidth / 2
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.gray
        return imageView
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15.0, weight: .light)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameLabel, timeLabel, contentLabel])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 5.0
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
 
    private func setupUI() {
        contentView.addSubview(avatarImageView)
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 5.0),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 10.0),
            stackView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 5.0),
            stackView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 5),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
    }
}

extension Tweet {
    
    var formattedDateString: String? {
        FormatDateUtils.format(rawDateString: dateString)
    }
}
