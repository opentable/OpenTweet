//
//  Networks.swift
//  OpenTweet
//
//  Created by Dante Li on 2024-01-14.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import Foundation

class Networks {
    
    private lazy var urlSession = URLSession.shared
    
    // Retrieves the contents of a URL and delivers the data asynchronously
    func download(url: URL) async -> Data? {
        do {
            let result: (Data, URLResponse) = try await URLSession.shared.data(from: url)
            return result.0
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
}
