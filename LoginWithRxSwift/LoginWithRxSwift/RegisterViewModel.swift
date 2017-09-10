//
//  RegisterViewModel.swift
//  LoginWithRxSwift
//
//  Created by DatouHsu on 9/3/17.
//  Copyright © 2017 datouHsu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RegisterViewModel {
  let username = Variable<String>("")
  let usernameUsable: Observable<Result>
  // input:
  let password = Variable<String>("")
  let repeatPassword = Variable<String>("")
  // output:
  let passwordUsable: Observable<Result>
  let repeatPasswordUsable: Observable<Result>

  init() {
    let service = ValidationService.instance

    usernameUsable = username.asObservable().flatMapLatest({ (username) in
      return service.validateUserName(username)
        .observeOn(MainScheduler.instance)
        .catchErrorJustReturn(.failed(message: "username出事了"))
    }).shareReplay(1)

    passwordUsable = password.asObservable().map { password in
        return service.validatePassword(password)
      }.shareReplay(1)

    repeatPasswordUsable = Observable.combineLatest(password.asObservable(), repeatPassword.asObservable()) {
   		 return service.validateRepeatedPassword($0, repeatedPasswordword: $1)
      }.shareReplay(1)
    
  }
  
}
