//
//  FollowStorageTest.swift
//  StackFollowTests
//
//  Created by Mac on 26.05.2026.
//

import XCTest
@testable import StackFollow

class FollowStorageTest: XCTestCase {
  
  let suiteName = "FollowStorageTestsSuite"
  var userDefaults: UserDefaults!
  
  func testFollowed() {
    userDefaults = UserDefaults(suiteName: suiteName)
    let storage = FollowStorage(userDefaults: userDefaults)
    XCTAssertFalse(storage.isFollowed(userId: 9))
    
    storage.follow(userId: 9)
    XCTAssertTrue(storage.isFollowed(userId: 9))
    
    storage.unfollow(userId: 9)
    XCTAssertFalse(storage.isFollowed(userId: 9))
    
    userDefaults.removePersistentDomain(forName: suiteName)
  }
}
