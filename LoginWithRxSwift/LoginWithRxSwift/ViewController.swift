//
//  ViewController.swift
//  LoginWithRxSwift
//
//  Created by DatouHsu on 9/3/17.
//  Copyright © 2017 datouHsu. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {

  @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var passwordLabel: UILabel!
  @IBOutlet weak var repeatPasswordTextField: UITextField!
  @IBOutlet weak var repeatPasswordLabel: UILabel!

  @IBOutlet weak var registerButton: UIButton!
  @IBOutlet weak var loginButton: UIBarButtonItem!

  let disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()
    let viewModel = RegisterViewModel()
    usernameTextField.rx.text.orEmpty.bind(to: viewModel.username).disposed(by: disposeBag)
    viewModel.usernameUsable.bind(to: usernameLabel.rx.validationResult).disposed(by: disposeBag)
    viewModel.usernameUsable.bind(to: passwordTextField.rx.inputEnabled).disposed(by: disposeBag)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

