//
//  LoginViewController.swift
//  LoginWithRxSwift
//
//  Created by DatouHsu on 9/16/17.
//  Copyright © 2017 datouHsu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {

  @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var loginButton: UIButton!

  var viewModel: LoginViewModel!

  let disposeBag = DisposeBag()

  override func viewDidLoad() {
      super.viewDidLoad()

    viewModel = LoginViewModel(input: (username: usernameTextField.rx.text.orEmpty.asDriver(),
                                       password: passwordTextField.rx.text.orEmpty.asDriver(),
                                       loginTaps: loginButton.rx.tap.asDriver()),
                               service: ValidationService.instance)

    viewModel.usernameUsable
      .drive(usernameLabel.rx.validationResult)
      .addDisposableTo(disposeBag)

    viewModel.loginButtonEnabled
      .drive(onNext: { [unowned self] valid in
        self.loginButton.isEnabled = valid
        self.loginButton.alpha = valid ? 1 : 0.5
      })
      .addDisposableTo(disposeBag)

    viewModel.loginResult
      .drive(onNext: { [unowned self] result in
        switch result {
        case let .ok(message):
          self.showAlert(message: message)
        case .empty:
          self.showAlert(message: "")
        case let .failed(message):
          self.showAlert(message: message)
        }
      })
      .addDisposableTo(disposeBag)
  }

  func showAlert(message: String) {
    let action = UIAlertAction(title: "確定", style: .default, handler: nil)
    let alertViewController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
    alertViewController.addAction(action)
    present(alertViewController, animated: true, completion: nil)
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }


}
