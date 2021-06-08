//
//  JSONError.swift
//  OpenTweet
//
//  Created by Sherman Shi on 5/17/21.
//  Copyright © 2021 OpenTable, Inc. All rights reserved.
//

import Foundation

enum JSONError: String, Error {
    case noDataError = "No data available to be fetched."
    case genericError = "There was an error fetching your data."
}
