//
//  UserServiceTest.swift
//  StackFollowTests
//
//  Created by Mac on 25.05.2026.
//

import XCTest
@testable import StackFollow

class UserServiceTest: XCTestCase {
  
  func testFetchUsersSuccess() async throws {
    
    let json = """
        {
            "items": []
        }
        """
    
    var mockSession = MockURLSession()
    mockSession.data = json.data(using: .utf8) ?? Data()
    let networkClient = NetworkClient(session: mockSession, networkMonitor: MockNetworkMonitor())
    let service = UserService(networkClient: networkClient)
    let users = try await service.fetchUsers()
    
    XCTAssertEqual(users.count, 0)
  }
  
  func testFetchUsersFailure() async throws {
    
    let json = """
        {
            "some": []
        }
        """
    
    var mockSession = MockURLSession()
    mockSession.data = json.data(using: .utf8) ?? Data()
    let networkClient = NetworkClient(session: mockSession, networkMonitor: MockNetworkMonitor())
    let service = UserService(networkClient: networkClient)
    
    do {
      let users = try await service.fetchUsers()
      XCTAssertNil(users)
    } catch let error as NetworkError {
      XCTAssertEqual(error, .decodingFailed)
    }
  }
}
