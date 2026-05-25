//
//  NetworkMonitor.swift
//  StackFollow
//
//  Created by Mac on 23.05.2026.
//

import Foundation
import Network

protocol NetworkMonitorProtocol {
  var isConnected: Bool { get }
}

final class NetworkMonitor: NetworkMonitorProtocol {
  
  static let shared = NetworkMonitor()
  private let monitor = NWPathMonitor()
  private let queue = DispatchQueue(label: "NetworkMonitor")
  
  private(set) var isConnected = true
  
  private init() {
    monitor.pathUpdateHandler = { [weak self] path in
      self?.isConnected = path.status == .satisfied
    }
    
    monitor.start(queue: queue)
  }
}
