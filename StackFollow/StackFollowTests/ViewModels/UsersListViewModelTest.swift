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
    let vm = UsersListViewModel(userService: MockUserService())
    vm.fetchUsers()
    vm.onUsersUpdated = {
      XCTAssertEqual(vm.users.count, 1)
    }
  }
  
  func testFetchUsersFail() async {
    var userService = MockUserService()
    userService.shouldSucceed = false
    let vm = UsersListViewModel(userService: userService)
    vm.fetchUsers()
    vm.onError = { error in
      XCTAssertEqual(vm.users.count, 0)
      XCTAssertEqual(error, NetworkError.invalidResponse.message)
    }
  }
  
  func testFetchUsersEmpty() async {
    var userService = MockUserService()
    userService.shouldBeEmpty = true
    let vm = UsersListViewModel(userService: userService)
    vm.fetchUsers()
    vm.onError = { error in
      XCTAssertEqual(error, "No users found")
    }
    
    vm.onUsersUpdated = {
      XCTAssertEqual(vm.users.count, 0)
    }
  }
  
  func testNumberOfRows() {
    let vm = UsersListViewModel(userService: MockUserService())
    XCTAssertEqual(vm.numberOfRows(), 0)
    
    vm.fetchUsers()
    vm.onUsersUpdated = {
      XCTAssertEqual(vm.numberOfRows(), 1)
    }
  }
  
  func testCellViewModelAt() {
    let vm = UsersListViewModel(userService: MockUserService())
    let cellVM = vm.cellViewModel(at: 5)
    XCTAssertNil(cellVM.imageURL)
    
    vm.fetchUsers()
    vm.onUsersUpdated = {
      let firstVM = vm.cellViewModel(at: 1)
      XCTAssertEqual(firstVM.name, "Jerry")
    }
  }
}
