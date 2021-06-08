//
//  Alert.swift
//  OpenTweet
//
//  Created by Sherman Shi on 5/15/21.
//  Copyright © 2021 OpenTable, Inc. All rights reserved.
//

import UIKit

class Alert: NSObject, UITextFieldDelegate {
    class func showDefaultAlert(title: String, message: String, vc: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: K.Alert.okTitle, style: .default, handler: nil))
        vc.present(alert, animated: true)
    }
    
    class func showBlockAlert(title: String, message: String, vc: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: K.Alert.cancelTitle, style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: K.Alert.blockTitle, style: .destructive, handler: nil))
        vc.present(alert, animated: true)
    }
}
