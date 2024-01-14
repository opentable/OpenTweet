//
//  ViewController.swift
//  OpenTweet
//
//  Created by Olivier Larivain on 9/30/16.
//  Copyright © 2016 OpenTable, Inc. All rights reserved.
//

import UIKit

class TimelineViewController: UITableViewController {

    private lazy var viewModel: TimelineViewModel = TimelineViewModelImpl()
    
    // MARK: - View Lifecycle
    
	override func viewDidLoad() {
		super.viewDidLoad()
        
        title = "Open Tweet"
        viewModel.fetchData()
	}

}

