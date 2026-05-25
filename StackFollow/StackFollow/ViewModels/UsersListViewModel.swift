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
  private(set) var users: [User] = []
  
  init(userService: UserServiceProtocol) {
    self.userService = userService
  }
  
  func fetchUsers() {
    onLoadingTriggered?(true)
    Task {
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
                               reputation: String(describing: user.reputation))
    }
    return UserCellViewModel(imageURL: nil, name: "", reputation: "")
  }
}
