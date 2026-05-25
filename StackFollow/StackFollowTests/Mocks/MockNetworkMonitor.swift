//
//  MockNetworkMonitor.swift
//  StackFollowTests
//
//  Created by Mac on 25.05.2026.
//

import Foundation
@testable import StackFollow

struct MockNetworkMonitor: NetworkMonitorProtocol {
  
  var isConnected = true
}
