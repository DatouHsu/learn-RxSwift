//
//  LoginViewModel.swift
//  LoginWithRxSwift
//
//  Created by DatouHsu on 9/16/17.
//  Copyright © 2017 datouHsu. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class LoginViewModel {

  let usernameUsable: Driver<Result>
  let loginButtonEnabled: Driver<Bool>
  let loginResult: Driver<Result>

  init(input: (username: Driver<String>, password: Driver<String>, loginTaps: Driver<Void>),
       service: ValidationService) {
    usernameUsable = input.username
      .flatMapLatest { username in
        return service.loginUsernameValid(username)
          .asDriver(onErrorJustReturn: .failed(message: "連接server失敗"))
    }

    let usernameAndPassword = Driver.combineLatest(input.username, input.password) {
      ($0, $1)
    }

    loginResult = input.loginTaps.withLatestFrom(usernameAndPassword)
      .flatMapLatest { (username, password) in
        return service.login(username, password: password)
          .asDriver(onErrorJustReturn: .failed(message: "連接server失敗"))
    }

    loginButtonEnabled = input.password
      .map { $0.characters.count > 0 }
      .asDriver()
  }

}
