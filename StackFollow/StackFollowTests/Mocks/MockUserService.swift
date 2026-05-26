//
//  MockUserService.swift
//  StackFollowTests
//
//  Created by Mac on 25.05.2026.
//

import Foundation
@testable import StackFollow

struct MockUserService: UserServiceProtocol {
  var shouldSucceed = true
  var shouldBeEmpty = false
  var shouldThrowRandom = false
  
  func fetchUsers() async throws -> [User] {
    if shouldSucceed {
      if shouldBeEmpty {
        return []
      }
      
      return [User(id: 1, displayName: "Jerry", reputation: 123, profileImage: "url")]
    } else {
      if shouldThrowRandom {
        let errorWithDescription = NSError(domain: "TestDomain",
                                           code: 1,
                                           userInfo: [NSLocalizedDescriptionKey: "Unknown error"])
        throw errorWithDescription
      }
      throw NetworkError.invalidResponse
    }
  }
}
