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
  let registerTaps = PublishSubject<Void>()
  // output:
  let passwordUsable: Observable<Result>
  let repeatPasswordUsable: Observable<Result>
  let registerButtonEnabled: Observable<Bool>
  let registerResult: Observable<Result>

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

    registerButtonEnabled = Observable.combineLatest(usernameUsable, passwordUsable, repeatPasswordUsable) {
              (username, password, repeatPassword) in
              username.isValid && password.isValid && repeatPassword.isValid
            }
            .distinctUntilChanged()
            .shareReplay(1)

    let usernameAndPassword = Observable.combineLatest(username.asObservable(), password.asObservable()) {
      ($0, $1)
    }

    registerResult = registerTaps.asObservable().withLatestFrom(usernameAndPassword)
            .flatMapLatest { (username, password) in
              return service.register(username, password: password)
                      .observeOn(MainScheduler.instance)
                      .catchErrorJustReturn(.failed(message: "註冊出事了"))
            }
            .shareReplay(1)
    
  }
  
}
