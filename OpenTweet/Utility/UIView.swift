//
//  UIView.swift
//  OpenTweetUIKit
//
//  Created by Landon Rohatensky on 2023-11-09.
//  Copyright © 2023 OpenTable, Inc. All rights reserved.
//

import UIKit

extension UIView {
    func setHeightConstraint(_ height: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: height).isActive = true
    }

    func setWidthConstraint(_ width: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: width).isActive = true
    }

    func anchorAspectRatio(_ multiplier: CGFloat = 1) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalTo: heightAnchor, multiplier: multiplier).isActive = true
    }

    func pin(superView: UIView, topMargin: CGFloat = 0, leftMargin: CGFloat = 0, bottomMargin: CGFloat = 0, rightMargin: CGFloat = 0) {
            self.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                self.topAnchor.constraint(equalTo: superView.topAnchor, constant: topMargin),
                self.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: leftMargin),
                self.bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: -bottomMargin),
                self.trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: -rightMargin)
            ])
        }

    func pinToSafeArea(superView: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false

        self.topAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        self.bottomAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        self.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: 0).isActive = true
        self.trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: 0).isActive = true
    }

    func centerHorizontally(in view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    func centerVertically(in view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    func centerInSuperview() {
        guard let superview = self.superview else {
            return
        }

        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            self.centerYAnchor.constraint(equalTo: superview.centerYAnchor)
        ])
    }
}
