//
//  UsersListViewModel.swift
//  StackFollow
//
//  Created by Mac on 23.05.2026.
//

import Foundation

final class UsersListViewModel {
  
  var onUsersUpdated: (() -> Void)?
  var onLoadingTriggered: ((Bool) -> Void)?
  var onError: ((String) -> Void)?
  
  private let userService: UserServiceProtocol
  private let followStorage: FollowStorageProtocol
  
  private(set) var users: [User] = []
  
  init(userService: UserServiceProtocol,
       followStorage: FollowStorageProtocol) {
    self.userService = userService
    self.followStorage = followStorage
  }
  
  func fetchUsers() async {
    onLoadingTriggered?(true)
    do {
      let fetchedUsers = try await userService.fetchUsers()
      users = Array(fetchedUsers.prefix(20))
      await MainActor.run {
        onLoadingTriggered?(false)
        onUsersUpdated?()
        
        if users.isEmpty {
          onError?("No users found")
        }
      }
    } catch let error as NetworkError {
      
      await MainActor.run {
        onLoadingTriggered?(false)
        onError?(error.message)
      }
    } catch {
      await MainActor.run {
        onLoadingTriggered?(false)
        onError?(error.localizedDescription)
      }
    }
  }
  
  func numberOfRows() -> Int {
    users.count
  }
  
  func cellViewModel(at index: Int) -> UserCellViewModel {
    if index < users.count {
      let user = users[index]
      return UserCellViewModel(imageURL: URL(string: user.profileImage),
                               name: user.displayName,
                               reputation: String(describing: user.reputation),
                               isFollowed: followStorage.isFollowed(userId: user.id))
    }
    return UserCellViewModel(imageURL: nil, name: "", reputation: "", isFollowed: false)
  }
  
  func toggleFollow(at index: Int) {
    guard index < users.count else { return }
    
    var user = cellViewModel(at: index)
    user.isFollowed.toggle()
    
    let userId = users[index].id
    user.isFollowed
    ? followStorage.follow(userId: userId)
    : followStorage.unfollow(userId: userId)
    
    onUsersUpdated?()
  }
}
