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

struct todoViewModel {

  private var todos = Variable<[Todo]>([])

  init() {
    fetchTodosAndUpdateObservableTodos()
  }

  // fetch todo from CoreData
  private func fetchTodosAndUpdateObservableTodos() {

  }
}
