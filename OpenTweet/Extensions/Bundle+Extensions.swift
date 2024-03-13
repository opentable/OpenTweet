//
//  Bundle+Extensions.swift
//  OpenTweet
//
//  Created by David Auld on 2024-03-12.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import Foundation
import Combine

extension Bundle {
  func readFile(file: String) -> AnyPublisher<Data, Error> {
    self.url(forResource: file, withExtension: nil)
      .publisher
      .tryMap { string in
        guard let data = try? Data(contentsOf: string) else {
          throw URLError(.cannotDecodeContentData)
        }
        return data
      }
      .mapError { error in
        return error
      }
      .eraseToAnyPublisher()
  }
  
  func decodeable<T: Decodable>(fileName: String) -> AnyPublisher<T, Error> {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    return readFile(file: fileName)
      .decode(type: T.self, decoder: decoder)
      .mapError { error in
        return error
      }
      .eraseToAnyPublisher()
  }
}
