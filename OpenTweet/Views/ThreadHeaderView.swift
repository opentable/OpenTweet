//
//  ThreadHeaderView.swift
//  OpenTweet
//
//  Created by HU QI on 2024-03-13.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import UIKit

final class ThreadHeaderView: UICollectionReusableView {
    static let reuseIdentifier: String = Constants.ThreadHeader.reuseIdentifier

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .italicSystemFont(ofSize: Constants.Dimens.FontSize.body)
        label.numberOfLines = 1
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutConstraints()
    }
    
    func setup(text: String?) {
        titleLabel.text = text
        setNeedsLayout()
    }
    
    private func addSubviews() {
        addSubview(titleLabel)
    }
    
    private func layoutConstraints() {
        let constraints: [NSLayoutConstraint] = [
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.Dimens.padding),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.Dimens.padding),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.Dimens.padding),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.Dimens.padding),
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
