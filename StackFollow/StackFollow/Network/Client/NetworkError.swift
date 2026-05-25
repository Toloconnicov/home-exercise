//
//  NetworkError.swift
//  StackFollow
//
//  Created by Mac on 24.05.2026.
//

import Foundation

enum NetworkError: Error, Equatable {
  case invalidURL
  case invalidResponse
  case noConnection
  case decodingFailed
  
  var message: String {
    switch self {
    case .invalidURL:
      return "Invalid URL"
    case .invalidResponse:
      return "Server error occured"
    case .noConnection:
      return "No internet connection"
    case .decodingFailed:
      return "Failed to decode data"
    }
  }
}
