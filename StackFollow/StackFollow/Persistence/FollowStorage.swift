//
//  FollowStorage.swift
//  StackFollow
//
//  Created by Mac on 25.05.2026.
//

import Foundation

protocol FollowStorageProtocol {
  func isFollowed(userId: Int) -> Bool
  func follow(userId: Int)
  func unfollow(userId: Int)
}

struct FollowStorage: FollowStorageProtocol {
  
  static let followedUsersKey = "followed_users"
  
  private let userDefaults: UserDefaults
  private var followedUserIdsStored: [Int] {
    return userDefaults.array(forKey: FollowStorage.followedUsersKey) as? [Int] ?? []
  }
  
  init(userDefaults: UserDefaults = .standard) {
    self.userDefaults = userDefaults
  }
  
  func isFollowed(userId: Int) -> Bool {
    followedUserIdsStored.contains(userId)
  }
  
  func follow(userId: Int) {
    var userIds = followedUserIdsStored
    userIds.append(userId)
    userDefaults.set(userIds, forKey: FollowStorage.followedUsersKey)
  }
  
  func unfollow(userId: Int) {
    var userIds = followedUserIdsStored
    userIds.removeAll(where: { $0 == userId})
    userDefaults.set(userIds, forKey: FollowStorage.followedUsersKey)
  }
}
