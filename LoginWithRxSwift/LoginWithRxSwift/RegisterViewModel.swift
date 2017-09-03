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

  init() {
    let service = ValidationService.instance

    usernameUsable = username.asObservable().flatMapLatest({ (username) in
      return service.validateUserName(username)
        .observeOn(MainScheduler.instance)
        .catchErrorJustReturn(.failed(message: "username出事了"))
    }).shareReplay(1)
  }
  
}
