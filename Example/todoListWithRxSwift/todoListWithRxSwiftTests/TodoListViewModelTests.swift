//
//  TodoListViewModelTests.swift
//  todoListWithRxSwift
//
//  Created by DatouHsu on 2017/8/24.
//  Copyright © 2017年 datouHsu. All rights reserved.
//

import XCTest
@testable import todoListWithRxSwift

class TodoListViewModelTests: XCTestCase {

  var vm: TodoListViewModel!

  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
    vm = TodoListViewModel()
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
    vm = nil
  }

  func testAddTwoTodos() {
    let oldCount = vm.getTodos().value.count
    vm.addTodo(withTodo: "test")
    vm.addTodo(withTodo: "test123")

    print("TODOS : ", vm.getTodos().value)
    XCTAssert(vm.getTodos().value.count == oldCount + 2)
  }

  func testRemoveTodo() {
    let oldCount = vm.getTodos().value.count
    vm.removeTodo(withIndex: 0)
    XCTAssert(vm.getTodos().value.count == oldCount - 1)
  }

  func testToggleTodo() {
    let isCompleted = vm.getTodos().value[0].isCompleted
    vm.toggleTodoIsCompleted(withIndex: 0)
    XCTAssert(vm.getTodos().value[0].isCompleted == !isCompleted)
  }

  func testPrintTodos() {
    print("TODOS : ", vm.getTodos().value)
  }

}

