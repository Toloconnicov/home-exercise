//
//  UserService.swift
//  StackFollow
//
//  Created by Mac on 23.05.2026.
//

import Foundation

protocol UserServiceProtocol {
  func fetchUsers() async throws -> [User]
}

struct UserService: UserServiceProtocol {
  private let networkClient: NetworkClientProtocol
  
  init(networkClient: NetworkClientProtocol) {
    self.networkClient = networkClient
  }
  
  func fetchUsers() async throws -> [User] {

    let url = URL(string: Constants.usersURL)
    do {
      let response: UsersResponse = try await networkClient.request(url: url)
      return response.items
    } catch {
      throw error
    }
  }
}
