//
//  todoViewModel.swift
//  todoListWithRxSwift
//
//  Created by DatouHsu on 2017/8/24.
//  Copyright © 2017年 datouHsu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct TodoListViewModel {

  private var todos = Variable<[Todo]>([])
  private var todoDataAccessProvider = TodoDataAccessProvider()
  private var disposeBag = DisposeBag()

  init() {
    fetchTodosAndUpdateObservableTodos()
  }

  public func getTodos() -> Variable<[Todo]> {
    return todos
  }

  // MARK: - fetching Todos from Core Data and update observable todos
  private func fetchTodosAndUpdateObservableTodos() {
    todoDataAccessProvider.fetchObservableData()
      .map({ $0 })
      .subscribe(onNext : { (todos) in
        self.todos.value = todos
      })
      .addDisposableTo(disposeBag)
  }

  public func addTodo(withTodo todo: String) {
    todoDataAccessProvider.addTodo(withTodo: todo)
  }

  public func toggleTodoIsCompleted(withIndex index: Int) {
    todoDataAccessProvider.toggleTodoIsCompleted(withIndex: index)
  }

  public func removeTodo(withIndex index: Int) {
    todoDataAccessProvider.removeTodo(withIndex: index)
  }

}

