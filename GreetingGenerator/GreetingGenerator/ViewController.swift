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

  let disposeBag = DisposeBag()
  let lastSelectedGreeting: Variable<String> = Variable("Hello")

  @IBOutlet weak var stateSegmentControl: UISegmentedControl!
  @IBOutlet weak var greetingsLabel: UILabel!
  @IBOutlet weak var greetingsTextField: UITextField!
  @IBOutlet weak var nameTextField: UITextField!

  @IBOutlet var greetingButtons: [UIButton]!

  override func viewDidLoad() {
    super.viewDidLoad()

    let nameObservible: Observable<String?> = nameTextField.rx.text.asObservable()
    let greetingObservible: Observable<String?> = greetingsTextField.rx.text.asObservable()
    // MARK: few way to do the same thing
//    nameObservible.subscribe({ (event: Event<String?>) in
//      switch event {
//      case .completed: print("Complete")
//      case .error(_): print("Error")
//      case .next(let string): print("\(string)")
//      }
//    })

//    nameObservible.subscribe(onNext: { (string: String?) in
//      self.greetingsLabel.text = string
//    })
//    nameObservible.bind(to: greetingsLabel.rx.text).addDisposableTo(disposeBag)

    let greetingWithNameObservible: Observable<String?> = Observable.combineLatest(nameObservible, greetingObservible) { (string1: String?, string2: String?) -> String? in
      return string1! + ", " + string2!
      }
    greetingWithNameObservible.bind(to: greetingsLabel.rx.text).addDisposableTo(disposeBag)

    let segmentControlObservible: Observable<Int> = stateSegmentControl.rx.value.asObservable()
    let stateObservable: Observable<State> = segmentControlObservible.map { (selectIndex: Int) -> State in
      return State(rawValue: selectIndex)!
    }
    let greetingTextFieldEnableObservable: Observable<Bool> = stateObservable.map { (state: State) -> Bool in
      return state == .useTextField
    }
    greetingTextFieldEnableObservable.bind(to: greetingsTextField.rx.isEnabled).addDisposableTo(disposeBag)

    let buttonEnableObservable: Observable<Bool> = greetingTextFieldEnableObservable.map { (greetingEnable: Bool) -> Bool in
      return !greetingEnable
    }
    greetingButtons.forEach { (button) in
      buttonEnableObservable.bind(to: button.rx.isEnabled).addDisposableTo(disposeBag)
      button.rx.tap.subscribe(onNext: { (nothing: Void) in
        self.lastSelectedGreeting.value = button.currentTitle!
      }).addDisposableTo(disposeBag)
    }
  }
}

