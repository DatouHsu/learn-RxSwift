//
//  ViewController.swift
//  RxSwiftWithDataSource
//
//  Created by DatouHsu on 9/29/17.
//  Copyright © 2017 polydice. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

struct Person {
  let name : String
  let age : Int
}

class ViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  let personArray = [
    Person(name: "name1", age: 11),
    Person(name: "name2", age: 12),
    Person(name: "name3", age: 13),
    Person(name: "name4", age: 12),
    Person(name: "name5", age: 12),
    Person(name: "name6", age: 12)
  ]

  let disposeBag = DisposeBag()
  var items : Observable<[Person]>!

  @IBAction func bb(_ sender: UIButton) {
    let newPersonArray = [
      Person(name: "name 0", age: 11)
    ]
    prependData(dataToPrepend: newPersonArray)
  }

  @IBAction func appendData(_ sender: UIButton) {
    let newPersonArray = [
      Person(name: "name 17", age: 18)
    ]
    appendData(dataToAppend : newPersonArray)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    items = Observable.just(personArray)
    bindData()

    tableView.rx.modelSelected(Person.self).subscribe(onNext: {
      person in
      print(person.name)
    }).addDisposableTo(disposeBag)

    tableView.rx.itemSelected.subscribe(onNext : {
      [weak self] indexPath in
      if let cell = self?.tableView.cellForRow(at: indexPath) as? personTableViewCell {
        cell.label1.text = "new value"
      }
    }).addDisposableTo(disposeBag)
  }

  private func bindData() {
    tableView.dataSource = nil
    items.bind(to: tableView.rx.items(cellIdentifier: "cell")) { (row, person, cell) in
      if let cellToUse = cell as? personTableViewCell {
        cellToUse.person = person
      }
      }.addDisposableTo(disposeBag)
  }

  private func prependData(dataToPrepend : [Person]) {
    let newObserver = Observable.just(dataToPrepend)
    items = Observable.combineLatest(items, newObserver) {
      $1+$0
    }
    bindData()
  }

  private func appendData(dataToAppend : [Person]) {
    let newObserver = Observable.just(dataToAppend)
    items = Observable.combineLatest(items, newObserver) {
      $0+$1
    }
    bindData()
  }


}

