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
  
  func fetchUsers() async throws -> [User] {
    if shouldSucceed {
      if shouldBeEmpty {
        return []
      }
      
      return [User(id: 1, displayName: "Jerry", reputation: 123, profileImage: "url")]
    } else {
      throw NetworkError.invalidResponse
    }
  }
}
