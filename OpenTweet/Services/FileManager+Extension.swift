//
//  FileManager+Extension.swift
//  OpenTweet
//
//  Created by Michael Charland on 2024-02-05.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import Foundation

extension FileManager {
    func loadData() -> [Tweet] {
        guard let path = Bundle.main.path(forResource:"timeline", ofType: "json"),
              let data = contents(atPath: path) else { return [] }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        guard let timeline = try? decoder.decode(Timeline.self, from: data) else {
            return []
        }

        return timeline.timeline
    }
}
