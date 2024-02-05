//
//  CustomLayout.swift
//  OpenTweet
//
//  Created by Michael Charland on 2024-02-05.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import UIKit

class CustomLayout: UICollectionViewFlowLayout {

    override func prepare() {
        super.prepare()
        estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    }
}
