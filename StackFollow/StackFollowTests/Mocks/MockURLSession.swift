//
//  MockURLSession.swift
//  StackFollowTests
//
//  Created by Mac on 25.05.2026.
//

import Foundation
@testable import StackFollow

struct MockURLSession: URLSessionProtocol {
  
  var shouldSucceed = true
  var data = Data()
  
  func data(from url: URL) async throws -> (Data, URLResponse) {
    var response: URLResponse?
    if shouldSucceed {
      response = HTTPURLResponse(url: url,
                                 statusCode: 200,
                                 httpVersion: nil,
                                 headerFields: nil)
    } else {
      response = HTTPURLResponse(url: url,
                                 statusCode: 500,
                                 httpVersion: nil,
                                 headerFields: nil)
    }
    
    return (data, response ?? URLResponse())
  }
}
