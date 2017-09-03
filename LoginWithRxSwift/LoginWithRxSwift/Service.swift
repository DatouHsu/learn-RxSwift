//
//  Service.swift
//  LoginWithRxSwift
//
//  Created by DatouHsu on 9/3/17.
//  Copyright © 2017 datouHsu. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ValidationService {
  static let instance = ValidationService()
  let minCharactersCount = 6
  private init() {}

  func validateUserName(_ username: String) -> Observable<Result> {
    if username.characters.count == 0 {
      return .just(.empty)
    }

    if username.characters.count < minCharactersCount {
      return .just(.failed(message: "帳號長度至少6個字元"))
    }
    return .just(.ok(message: "帳號可用"))
  }

}
