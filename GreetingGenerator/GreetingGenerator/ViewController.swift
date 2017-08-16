//
//  ViewController.swift
//  GreetingGenerator
//
//  Created by DatouHsu on 2017/8/16.
//  Copyright © 2017年 datouHsu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

  enum State: Int {
    case useButtons
    case useTextField
  }

  @IBOutlet weak var stateSegmentControl: UISegmentedControl!
  @IBOutlet weak var greetingsLabel: UILabel!
  @IBOutlet weak var greetingsTextField: UITextField!
  @IBOutlet weak var nameTextField: UITextField!

  @IBOutlet var greetingButtons: [UIButton]!

  override func viewDidLoad() {
    super.viewDidLoad()

    let nameObservible: Observable<String?> = nameTextField.rx.text.asObservable()
    nameObservible.subscribe({ (event: Event<String?>) in
      switch event {
      case .completed: print("Complete")
      case .error(_): print("Error")
      case .next(let string): print("\(string)")
      }
    })
  }

}

