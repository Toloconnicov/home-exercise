//
//  NetworkClientTest.swift
//  StackFollowTests
//
//  Created by Mac on 25.05.2026.
//

import XCTest
@testable import StackFollow

class NetworkClientTest: XCTestCase {
  
  let url = URL(string: "anyURL")
  
  func testRequestSuccess() async throws {
    let json = """
        {
            "items": []
        }
        """
    
    var mockSession = MockURLSession()
    mockSession.data = json.data(using: .utf8) ?? Data()
    
    let networkClient = NetworkClient(session: mockSession, networkMonitor: MockNetworkMonitor())
    
    let response: UsersResponse = try await networkClient.request(url: url)
    
    XCTAssertEqual(response.items.count, 0)
  }
  
  func testRequestFailure() async throws {
    
    var mockSession = MockURLSession()
    mockSession.shouldSucceed = false
    let networkClient = NetworkClient(session: mockSession, networkMonitor: MockNetworkMonitor())
    
    do {
      let response: UsersResponse = try await networkClient.request(url: url)
      XCTAssertNil(response)
    } catch let error as NetworkError {
      XCTAssertEqual(error, .invalidResponse)
    }
  }
  
  func testRequestURLFail() async throws {
    
    let networkClient = NetworkClient(session: MockURLSession(), networkMonitor: MockNetworkMonitor())
    
    do {
      let wrongURL = URL(string: "")
      let response: UsersResponse = try await networkClient.request(url: wrongURL)
      XCTAssertNil(response)
    } catch let error as NetworkError {
      XCTAssertEqual(error, .invalidURL)
    }
  }
  
  func testNoConnection() async throws {
    var mockNetworkMonitor = MockNetworkMonitor()
    mockNetworkMonitor.isConnected = false
    let networkClient = NetworkClient(session: MockURLSession(),
                                      networkMonitor: mockNetworkMonitor)
    
    do {
      let response: UsersResponse = try await networkClient.request(url: url)
      XCTAssertNil(response)
    } catch let error as NetworkError {
      XCTAssertEqual(error, .noConnection)
    }
  }
  
  func testRequestDecodingFailed() async throws {
    let json = """
          {
              "some": []
          }
          """
    
    var mockSession = MockURLSession()
    mockSession.data = json.data(using: .utf8) ?? Data()
    let networkClient = NetworkClient(session: mockSession,
                                      networkMonitor: MockNetworkMonitor())
    do {
      let response: UsersResponse = try await networkClient.request(url: url)
      XCTAssertNil(response)
    } catch let error as NetworkError {
      XCTAssertEqual(error, .decodingFailed)
    }
  }
}
