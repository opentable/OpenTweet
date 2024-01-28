//
//  FileLoader.swift
//  OpenTweet
//
//  Created by Sean Lee on 2024-01-26.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import Foundation

enum FileLoader {
    static func parseLocalJSONFile<T: Decodable>(fileName: String, fileType: String = "json", decodingType: T.Type) -> T? {
        if let path = Bundle.main.path(forResource: fileName, ofType: fileType) {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let decoder = JSONDecoder()
                let parsedData = try decoder.decode(decodingType, from: data)
                return parsedData
            } catch {
                print("Error parsing JSON file: \(error)")
            }
        } else {
            print("JSON file not found.")
        }
        return nil
    }
}
