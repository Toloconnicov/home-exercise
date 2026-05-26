//
//  MockFollowStorage.swift
//  StackFollowTests
//
//  Created by Mac on 25.05.2026.
//

import Foundation
@testable import StackFollow

class MockFollowStorage: FollowStorageProtocol {
  var followedIds: [Int] = []
  
  func isFollowed(userId: Int) -> Bool {
    return followedIds.contains(userId)
  }
  
  func follow(userId: Int) {
    followedIds.append(userId)
  }
  
  func unfollow(userId: Int) {
    followedIds.removeAll(where: { $0 == userId })
  }
}
