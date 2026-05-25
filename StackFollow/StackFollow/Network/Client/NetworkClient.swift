//
//  NetworkClient.swift
//  StackFollow
//
//  Created by Mac on 23.05.2026.
//

import Foundation

enum Constants {
  static let usersURL = "https://api.stackexchange.com/2.2/users?site=stackoverflow"
}

protocol NetworkClientProtocol {
  func request<T: Decodable>(url: URL?) async throws -> T
}

struct NetworkClient: NetworkClientProtocol {
  
  private let session: URLSessionProtocol
  private let networkMonitor: NetworkMonitorProtocol
  
  init(session: URLSessionProtocol = URLSession.shared,
       networkMonitor: NetworkMonitorProtocol = NetworkMonitor.shared) {
    self.session = session
    self.networkMonitor = networkMonitor
  }
  
  func request<T: Decodable>(url: URL?) async throws -> T {
    
    guard let url else {
      throw NetworkError.invalidURL
    }
    
    guard networkMonitor.isConnected else {
      throw NetworkError.noConnection
    }
    
    let (data, response) = try await session.data(from: url)
    
    guard let httpResponse = response as? HTTPURLResponse,
          200...299 ~= httpResponse.statusCode else {
      throw NetworkError.invalidResponse
    }
    
    do {
      return try JSONDecoder().decode(T.self, from: data)
    } catch {
      throw NetworkError.decodingFailed
    }
  }
}
