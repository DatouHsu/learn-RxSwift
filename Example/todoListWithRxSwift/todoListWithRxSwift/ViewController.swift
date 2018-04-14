//
//  ViewController.swift
//  todoListWithRxSwift
//
//  Created by DatouHsu on 2017/8/23.
//  Copyright © 2017年 datouHsu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

  @IBOutlet weak var todoListTableView: UITableView!
  @IBOutlet weak var addTodoButton: UIBarButtonItem!
  var todoListViewModel = TodoListViewModel()
  var disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()
    populateTodoListTableView()
    setupTodoListTableViewCellWhenTapped()
    setupTodoListTableViewCellWhenDeleted()
    setupActionWhenButtonAddTodoTapped()
  }

  private func populateTodoListTableView() {
    todoListViewModel.getTodos().asObservable()
      .bind(to: todoListTableView.rx.items(cellIdentifier: "todoCellIdentifier", cellType: UITableViewCell.self)) { (row, element, cell) in
      cell.textLabel?.text = element.todo
      if element.isCompleted {
        cell.accessoryType = .checkmark
      } else {
        cell.accessoryType = .none
      }
    }.disposed(by: disposeBag)
  }

  private func setupTodoListTableViewCellWhenTapped() {
    todoListTableView.rx.itemSelected.subscribe(onNext: { indexPath in
      self.todoListTableView.deselectRow(at: indexPath, animated: false)
      self.todoListViewModel.toggleTodoIsCompleted(withIndex: indexPath.row)
    }).disposed(by: disposeBag)
  }

  private func setupTodoListTableViewCellWhenDeleted() {
    todoListTableView.rx.itemDeleted.subscribe(onNext: { (indexPath) in
      self.todoListViewModel.removeTodo(withIndex: indexPath.row)
    }).disposed(by: disposeBag)
  }

  private func setupActionWhenButtonAddTodoTapped() {
    addTodoButton.rx.tap.subscribe(onNext: {
      let addTodoAlert = UIAlertController(title: "Add Todo", message: "Enter your string", preferredStyle: .alert)

      addTodoAlert.addTextField(configurationHandler: nil)
      addTodoAlert.addAction(UIAlertAction(title: "Add", style: .default, handler: { al in
        let todoString = addTodoAlert.textFields![0].text
        if !(todoString!.isEmpty) {
          self.todoListViewModel.addTodo(withTodo: todoString!)
        }
      }))

      addTodoAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))

      self.present(addTodoAlert, animated: true, completion: nil)
    }).disposed(by: disposeBag)
  }

}

