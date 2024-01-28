//
//  UIViewExtensions.swift
//  OpenTweet
//
//  Created by Sean Lee on 2024-01-26.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import UIKit

extension UIView {
    /// `frame.size.width`
    var width: CGFloat {
        get {
            return frame.size.width
        }
        
        set {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
    }
    
    /// `frame.size.height`
    var height: CGFloat {
        get {
            return frame.size.height
        }
        
        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
    }
    
    /// Returns `safeAreaLayoutGuide.topAnchor` if the current device is running iOS 11 otherwise it returns `topAnchor`
    var safeTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.topAnchor
        }
        return topAnchor
    }
    
    /// Returns `safeAreaLayoutGuide.leadingAnchor` if the current device is running iOS 11 otherwise it returns `leadingAnchor`
    var safeLeadingAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.leadingAnchor
        }
        return leadingAnchor
    }
    
    /// Returns `safeAreaLayoutGuide.trailingAnchor` if the current device is running iOS 11 otherwise it returns `trailingAnchor`
    var safeTrailingAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.trailingAnchor
        }
        return trailingAnchor
    }
    
    /// Returns `safeAreaLayoutGuide.bottomAnchor` if the current device is running iOS 11 otherwise it returns `bottomAnchor`
    var safeBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.bottomAnchor
        }
        return bottomAnchor
    }
    
    /// Helper method to add rounded corners to your view
    /// - Parameter radius: The corner radius
    func makeRoundedCornerOfRadius(radius: CGFloat) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
    
//    /// Helper method to round a specific set of corners to your view (Example: Round the top left and top right corner, but not the bottom corners)
//    /// - Parameters:
//    ///   - corners: A `UIRectCorner` instance
//    ///   - radius: The radius to round the corners
//    func makeRoundedCorners(_ corners: UIRectCorner, radius: CGFloat) {
//        let mask = CAShapeLayer()
//        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius)).cgPath
//        mask.path = path
//        layer.mask = mask
//    }
//    
//    /// Makes a view circular. This method assumes the view is fully laid out and is at the intended width. If the view's `width` is dynamic, you
//    /// will need to either call this method in `layoutSubviews` or calculate the width ahead of time and use `func makeRoundedCornerOfRadius(radius: CGFloat)` instead
//    func makeCircular() {
//        makeRoundedCornerOfRadius(radius: width / 2)
//    }
//    
//    /// Makes a view edge circular. This method assumes the view is fully laid out and is at the intended width. If the view's `height` is dynamic, you
//    /// will need to either call this method in `layoutSubviews` or calculate the height ahead of time and use `func makeRoundedCornerOfRadius(radius: CGFloat)` instead
//    func makeRoundedEdges() {
//        makeRoundedCornerOfRadius(radius: height / 2)
//    }
    
    /// Returns a list of constraints that will pin the receiver to the passed in `view` or - if unspecified -  its `superview`
    /// - Parameters:
    ///   - view: The view to pin
    ///   - edgeInsets: Use this to specify padding when pinning your constraints
    ///   - shouldPinToSafeArea: Specifying `true` will pin the receiver to the `view` / `superview` safe area layout guide
    func pinConstraints(_ view: UIView? = nil,
                        edgeInsets: UIEdgeInsets = .zero,
                        shouldPinToSafeArea: Bool = false) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        guard let viewToPin = view ?? superview else {
            return []
        }
        
        let topAnchor: NSLayoutYAxisAnchor = shouldPinToSafeArea
            ? viewToPin.safeTopAnchor
            : viewToPin.topAnchor
        let topConstraint = self.topAnchor.constraint(
            equalTo: topAnchor,
            constant: edgeInsets.top
        )
        
        let leadingAnchor: NSLayoutXAxisAnchor = shouldPinToSafeArea
            ? viewToPin.safeLeadingAnchor
            : viewToPin.leadingAnchor
        let leadingConstraint = self.leadingAnchor.constraint(
            equalTo: leadingAnchor,
            constant: edgeInsets.left
        )
        
        let trailingAnchor: NSLayoutXAxisAnchor = shouldPinToSafeArea
            ? viewToPin.safeTrailingAnchor
            : viewToPin.trailingAnchor
        
        let trailingConstraint = self.trailingAnchor.constraint(
            equalTo: trailingAnchor,
            constant: -abs(edgeInsets.right)
        )
        
        let bottomAnchor: NSLayoutYAxisAnchor = shouldPinToSafeArea
            ? viewToPin.safeBottomAnchor
            : viewToPin.bottomAnchor
        
        let bottomConstraint = self.bottomAnchor.constraint(
            equalTo: bottomAnchor,
            constant: -abs(edgeInsets.bottom)
        )
        
        let constraints: [NSLayoutConstraint] = [
            topConstraint,
            leadingConstraint,
            trailingConstraint,
            bottomConstraint,
        ]
        return constraints
    }
    
    /// Pins the receiver to its superview
    func pinToSuperView(shouldPinToSafeArea: Bool = false) {
        guard superview != nil else {
            return
        }
        
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(pinConstraints(shouldPinToSafeArea: shouldPinToSafeArea))
    }
}
