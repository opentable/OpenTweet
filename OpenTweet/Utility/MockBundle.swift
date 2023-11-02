//
//  MockBundle.swift
//  OpenTweet
//
//  Created by Landon Rohatensky on 2023-11-02.
//

import Foundation

class MockBundle: Bundle {
    var mockJSONData: Data?

    override func url(forResource name: String?, withExtension ext: String?) -> URL? {
        if let jsonData = mockJSONData {
            // Create a temporary directory and save the JSON data there
            let tempDirectory = FileManager.default.temporaryDirectory
            let tempURL = tempDirectory.appendingPathComponent("mock.json")

            do {
                try jsonData.write(to: tempURL)
                return tempURL
            } catch {
                return nil
            }
        }
        return nil
    }
}
