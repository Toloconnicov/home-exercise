//
//  UsersListViewModelTest.swift
//  StackFollowTests
//
//  Created by Mac on 25.05.2026.
//

import XCTest
@testable import StackFollow

class UsersListViewModelTest: XCTestCase {
  
  func testFetchUsersSuccess() async {
    let vm = UsersListViewModel(userService: MockUserService(), followStorage: MockFollowStorage())
    await vm.fetchUsers()
    XCTAssertEqual(vm.users.count, 1)
  }
  
  func testFetchUsersFail() async {
    var userService = MockUserService()
    userService.shouldSucceed = false
    let vm = UsersListViewModel(userService: userService, followStorage: MockFollowStorage())
    let expectation = expectation(description: "onError called")
    
    vm.onError = { error in
      XCTAssertEqual(error, NetworkError.invalidResponse.message)
      expectation.fulfill()
    }
    await vm.fetchUsers()
    wait(for: [expectation], timeout: 1)
    XCTAssertEqual(vm.users.count, 0)
  }
  
  func testFetchUsersFailUnknownError() async {
    var userService = MockUserService()
    userService.shouldSucceed = false
    userService.shouldThrowRandom = true
    
    let vm = UsersListViewModel(userService: userService, followStorage: MockFollowStorage())
    let expectation = expectation(description: "onError called")
    
    vm.onError = { error in
      XCTAssertNotEqual(error, NetworkError.invalidResponse.message)
      XCTAssertEqual(error.description, "Unknown error")
      expectation.fulfill()
    }
    await vm.fetchUsers()
    wait(for: [expectation], timeout: 1)
    XCTAssertEqual(vm.users.count, 0)
  }
  
  func testFetchUsersEmpty() async {
    var userService = MockUserService()
    userService.shouldBeEmpty = true
    let vm = UsersListViewModel(userService: userService, followStorage: MockFollowStorage())
    let expectation = expectation(description: "onError called")
    
    vm.onError = { error in
      XCTAssertEqual(error, "No users found")
      expectation.fulfill()
    }
    await vm.fetchUsers()
    wait(for: [expectation], timeout: 1)
    XCTAssertEqual(vm.users.count, 0)
  }
  
  func testNumberOfRows() async {
    let vm = UsersListViewModel(userService: MockUserService(), followStorage: MockFollowStorage())
    XCTAssertEqual(vm.numberOfRows(), 0)
    await vm.fetchUsers()
    XCTAssertEqual(vm.numberOfRows(), 1)
  }
  
  func testCellViewModelAt() async {
    let vm = UsersListViewModel(userService: MockUserService(), followStorage: MockFollowStorage())
    let cellVM = vm.cellViewModel(at: 5)
    XCTAssertNil(cellVM.imageURL)
    await vm.fetchUsers()
    let firstVM = vm.cellViewModel(at: 0)
    XCTAssertEqual(firstVM.name, "Jerry")
  }
  
  func testToggleFollow() async {
    let followStorage = MockFollowStorage()
    followStorage.followedIds = [2, 3]
    let vm = UsersListViewModel(userService: MockUserService(), followStorage: followStorage)
    await vm.fetchUsers()
    XCTAssertEqual(vm.users.first?.id, 1)
    
    vm.toggleFollow(at: 0)
    XCTAssertTrue(followStorage.followedIds.contains(1))
    
    vm.toggleFollow(at: 0)
    XCTAssertFalse(followStorage.followedIds.contains(1))
    
    vm.toggleFollow(at: 99)
    XCTAssertFalse(followStorage.followedIds.contains(1))
  }
}
