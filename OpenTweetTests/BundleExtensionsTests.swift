//
//  BundleTests.swift
//  OpenTweet
//
//  Created by David Auld on 2024-03-13.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import Combine
import XCTest
@testable import OpenTweet

class BundleExtensionsTests: XCTestCase {
  
  struct MockData: Decodable {
    let id: Int
    let name: String
    let date: Date
  }
  
  var cancellables: Set<AnyCancellable> = []
  
  override func tearDown() {
    cancellables.removeAll()
  }
  
  func test_readFile() {
    let expectation = XCTestExpectation(description: "Load data from file")
    
    Bundle(for: type(of: self)).readFile(file: "MockData.json")
      .sink(receiveCompletion: { completion in
        if case .failure(let error) = completion {
          XCTFail("Error loading file: \(error)")
        }
      }, receiveValue: { data in
        XCTAssertNotNil(data, "Data should not be nil")
        expectation.fulfill()
      })
      .store(in: &cancellables)
    
    wait(for: [expectation], timeout: 5.0)
  }
  
  func test_decodable() {
    let expectation = XCTestExpectation(description: "Decode JSON to Model")
    let bundle = Bundle(for: type(of: self))
    let decodable: AnyPublisher<MockData, Error> = bundle.decodable(fileName: "MockData.json")
    
    decodable
      .sink(receiveCompletion: { completion in
        if case .failure(let error) = completion {
          XCTFail("Error decoding file: \(error)")
        }
      }, receiveValue: { mockData in
        XCTAssertEqual(mockData.name, "Test Item")
        expectation.fulfill()
      })
      .store(in: &cancellables)
    
    wait(for: [expectation], timeout: 5.0)
  }
}
